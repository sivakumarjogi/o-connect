import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewCalendarProvider extends ChangeNotifier {
  DateTime selectedMonth = DateTime.now();
  DateTime selectedDay = DateTime.now();

  bool isYearView = false;
  bool isWeekView = false;



  String selectedItem = '';

  void changeMonth(int offset) {
    selectedMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + offset,
      selectedMonth.day,
    );
    notifyListeners();
  }

  void isCalendarViewCha(bool offset) {
    isWeekView=offset;
    notifyListeners();
  }

  String formatMonthYear(DateTime dateTime) {
    return DateFormat('MMMM yyyy').format(dateTime);
  }


}
