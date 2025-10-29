import 'package:flutter/rendering.dart';
import 'package:myapp/week08/calendar_scheduler/model/schedule_model.dart';
import 'package:myapp/week08/calendar_scheduler/repository/schedule_repository.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ScheduleProvider extends ChangeNotifier{
  final ScheduleRepository repository;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  Map<DateTime, List<ScheduleModel>> cache = {};

  ScheduleProvider({
    required this.repository,
  }) : super(){
     getSchedules(date: selectedDate);
  }

  void getSchedules({
    required DateTime date,
  }) async {
    final resp = await repository.getSchedules(date: date);

    cache.update(date, (value) => resp, ifAbsent: () => resp);

    notifyListeners();
  }

  void createSchedule({
    required ScheduleModel schedule,
  }) async {
    final targetDate = schedule.date;

    final uuid =Uuid();

    final tempId = uuid.v4();
    final newSchedule = schedule.copyWith(
      id: tempId,
    );

    cache.update(
      targetDate,
      (value) => [
        ...value,
        newSchedule,
      ]..sort(
        (a, b) => a.startTime.compareTo(
          b.startTime,
        ),
    ),
    ifAbsent: () => [newSchedule],
    );

    notifyListeners();

    try{
      final savedSchedule = await repository.createSchedule(schedule: schedule);

      cache.update(
        targetDate,
        (value) => value
        .map((e) => e.id == tempId
        ? e.copyWith(
          id: savedSchedule,
        )
        :e)
        .toList(),
      );
    } catch (e) {
      cache.update(
        targetDate,
        (value) => value.where((e) => e.id !=tempId).toList(),

      );
    }

    final savedSchedule = await repository.createSchedule(schedule: schedule);

    cache.update(key, update)
  }
}