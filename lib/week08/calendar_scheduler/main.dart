import 'package:myapp/week05/calender_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myapp/week05/calender_scheduler/database/drift_database.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/week05/calender_scheduler/repository/schedule_repository.dart';
import 'package:myapp/week05/calender_scheduler/provider/schedule_provider.dart';
import 'package:provider/provider.dart';

void main() async {

  // 플러터 프레임워크가 준비될 때까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();   // intl 패키지 초기화(다국어화)

  final database = LocalDatabase();   // 데이터베이스 생성

  // GetIt에 데이터베이스 변수 주입하기
  GetIt.I.registerSingleton<LocalDatabase>(database);

  final repository = ScheduleRepository();
  final scheduleProvider = ScheduleProvider(repository: repository);

  runApp(  
    ChangeNotifierProvider(  
      create: (_) => scheduleProvider,
      child: MaterialApp(  
        home: HomeScreen(),
      ),
    )    
  );
}