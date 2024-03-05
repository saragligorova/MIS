import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'exams.dart';

class CalendarWidget extends StatelessWidget {
  final List<Exam> exams;

  const CalendarWidget({super.key, required this.exams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exams'),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: _getCalendarDataSource(),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell) {
            _handleDateTap(context, details.date!);
          }
        },
      ),
    );
  }

  _DataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];

    for (var exam in exams) {
      appointments.add(Appointment(
        startTime: exam.time,
        endTime: exam.time.add(const Duration(hours: 2)),
        subject: exam.course,
      ));
    }

    return _DataSource(appointments);
  }

  void _handleDateTap(BuildContext context, DateTime selectedDate) {
    List<Exam> selectedExams = exams
        .where((exam) =>
    exam.time.year == selectedDate.year &&
        exam.time.month == selectedDate.month &&
        exam.time.day == selectedDate.day)
        .toList();

    if (selectedExams.isNotEmpty) {
      _showExamsDialog(context, selectedDate, selectedExams);
    }
  }

  void _showExamsDialog(
      BuildContext context, DateTime selectedDate, List<Exam> exams) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exams on ${selectedDate.toLocal()}'),
          content: Column(
            children: exams
                .map((exam) => Text(
                '${exam.course} - ${exam.time.hour}:${exam.time.minute}'))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}