class CalendarDateInfo {
  final DateTime date;
  final String  applyBorder;
  final bool enabled;
  final bool isToday;
  CalendarDateInfo({
    required this.date,
    required this.applyBorder,
    required this.enabled,
    required this.isToday,
  });
  CalendarDateInfo copyWith({
    DateTime? date,
    String? applyBorder,
    bool? enabled,
    bool? isToday,
  }) {
    return CalendarDateInfo(
      date: date ?? this.date,
      applyBorder: applyBorder ?? this.applyBorder,
      enabled: enabled ?? this.enabled,
      isToday: isToday ?? this.isToday,
    );
  }
}