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
    required DateTime date,
  }) async {
    final resp = await repository.get
  }
}