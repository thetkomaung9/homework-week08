import 'dart:async';
import 'dart:io';

import 'package:myapp/week08/calendar_scheduler/model/schedule_model.dart';
import 'package:dio/dio.dart';

class ScheduleRepository {
  final _dio= Dio();
  final _targetUrl = 'http://'
}