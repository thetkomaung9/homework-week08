import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

// ✅ 테이블 정의 (Schedule에 필요한 모든 필드 포함)
class Schedules extends Table {
  IntColumn get id => integer().autoIncrement()(); // PK
  IntColumn get startTime => integer()(); // 시작 시간
  IntColumn get endTime => integer()(); // 종료 시간
  TextColumn get content => text()(); // 일정 내용
  DateTimeColumn get date => dateTime()(); // 날짜
}

// ✅ 데이터베이스 정의
@DriftDatabase(tables: [Schedules])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  // 일정 목록 실시간 감시
  Stream<List<Schedule>> watchSchedules(DateTime date) {
    return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  }

  // 일정 추가
  Future<int> createSchedule(SchedulesCompanion data) {
    return into(schedules).insert(data);
  }

  // 일정 삭제
  Future<int> removeSchedule(int id) {
    return (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  int get schemaVersion => 1;
}

// ✅ Drift 연결 설정
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
