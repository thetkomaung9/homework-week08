import 'package:myapp/week08/calendar_scheduler/component/today_banner.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/week08/calendar_scheduler/database/drift_database.dart';
import 'package:myapp/week08/calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:myapp/week08/calendar_scheduler/const/colors.dart';
import 'package:myapp/week08/calendar_scheduler/component/today_banner.dart';
import 'package:myapp/week08/calendar_scheduler/component/schedule_card.dart';
import 'package:myapp/week08/calendar_scheduler/component/main_calendar.dart';
import 'package:flutter/material.dart';
import 'package:myapp/week08/calendar_scheduler/provider/schedule_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  DateTime selectedDate = DateTime.utc(     // 선택된 날짜를 관리할 변수
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();

    final selectedDate = provider.selectedDate;

    final schedules = provider.cache[selectedDate] ?? [];

    return Scaffold(  

      floatingActionButton: FloatingActionButton(     // 새 일정 버튼
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(     // BottomSheet 열기
            context: context,
            isDismissible: true,    // 배경 탭 했을 때 BottomSheet 닫기
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate,   // 선택된 날짜 (selectedDate) 넘겨주기
            ),
            // BottomSHeet의 높이를 화면의 최대 높이로 정의하고 스크롤 가능하게 변경
            isScrollControlled: true,
          );
        },
        child: Icon(  
          Icons.add,
        ),
      ),

      body: SafeArea(     // 시스템 UI 피해서 UI 구현하기
        child: Column(    // 달력과 리스트를 세로로 배치
          children: [  
            // 미리 작업해둔 달력 위젯 보여주기
            MainCalendar(
              selectedDate: selectedDate,   // 선택된 날짜 전달하기              
              onDaySelected: (selectedDate, focusedDate) =>
                onDaySelected(selectedDate, focusedDate, context), // 날짜가 선택됐을 때 실행할 함수              
            ),
            
            SizedBox(height: 8.0,),
            
            TodayBanner(      // 배너 추가하기
              selectedDate: selectedDate,
              count: schedules.length,
            ),
           
            SizedBox(height: 8.0),
            
            Expanded(   // 남는 공간을 모두 차지하기
              child: ListView.builder(  
                // 리스트에 입력할 값들의 총 개수
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  // 현재 index에 해당되는 일정
                  final schedule = schedules[index];

                  return Dismissible(  
                    key: ObjectKey(schedule.id),    // 유니크한 키값
                    // 밀기 방향(왼쪽에서 오른쪽으로)
                    direction: DismissDirection.startToEnd,
                    // 밀기 했을 때 실행할 함수
                    onDismissed: (DismissDirection direction) {
                      provider.deleteSchedule(date: selectedDate, id: schedule.id);
                    },
                    child: Padding(     // 좌우로 패딩을 추가해서 UI 개선
                      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                      child: ScheduleCard(   // 구현해둔 일정 카드
                        startTime: schedule.startTime,
                        endTime: schedule.endTime,
                        content: schedule.content,
                      ),
                    ),
                  );
                },                
              )
            )            
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate, BuildContext context) {
    // 날짜 선택될 때마다 실행할 함수
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(  
      date: selectedDate,
    );
    provider.getSchedules(date: selectedDate);
  }
}