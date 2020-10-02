class Time {
  DateTime now = DateTime.now();

  List<String> getDayList() {
    List<String> inputText = [
      'Now',
      'Today',
      'Tomorrow',
    ];
    // Duration difference = DateTime(now.year + 1, now.month, now.day).difference(now);
    Duration difference = DateTime(now.year + 1, 1, 1).difference(now);
    for (int i = 2; i <= difference.inDays; i++) {
      String nextDay = formatDay(now.add(Duration(days: i)));
      inputText.add(nextDay);
    }
    return inputText;
  }

  List<String> getHourList() {
    List<String> inputText = [
      'Anytime',
      'Morning',
      'Afternoon',
      'Evening',
      'Night',
    ];

    DateTime roundedTime = roundTimeEach15Minutes();
    while (roundedTime.day == now.day) {
      inputText.add(formatTime(roundedTime));
      roundedTime = roundedTime.add(Duration(minutes: 15));
    }
    return inputText;
  }

  String formatDay(DateTime dateTime) {
    return '${getWeekDay(dateTime)}${dateTime.day}';
  }

  String formatTime(DateTime dateTime) {
    String hours = '${dateTime.hour}'.padRight(2, '0');
    String minutes = '${dateTime.minute}'.padLeft(2, '0');
    return '$hours:$minutes';
  }

  String getWeekDay(DateTime dateTime) {
    if (dateTime.weekday == 1) return 'Mo';
    if (dateTime.weekday == 2) return 'Tu';
    if (dateTime.weekday == 3) return 'We';
    if (dateTime.weekday == 4) return 'Th';
    if (dateTime.weekday == 5) return 'Fr';
    if (dateTime.weekday == 6) return 'Sa';
    if (dateTime.weekday == 7) return 'Su';
    return '';
  }

  String getMonth(DateTime dateTime) {
    if (dateTime.month == 1) return 'Jan';
    if (dateTime.month == 2) return 'Feb';
    if (dateTime.month == 3) return 'Mar';
    if (dateTime.month == 4) return 'Apr';
    if (dateTime.month == 5) return 'May';
    if (dateTime.month == 6) return 'Jun';
    if (dateTime.month == 7) return 'Jul';
    if (dateTime.month == 8) return 'Aug';
    if (dateTime.month == 9) return 'Sep';
    if (dateTime.month == 10) return 'Oct';
    if (dateTime.month == 11) return 'Nov';
    if (dateTime.month == 12) return 'Dec';
    return '';
  }

  DateTime roundTimeEach15Minutes() {
    DateTime now = DateTime.now();
    if (now.minute == 0 ||
        now.minute == 15 ||
        now.minute == 30 ||
        now.minute == 45) return now;
    if (now.minute < 15) return now.add(Duration(minutes: 15 - now.minute));
    if (now.minute < 30) return now.add(Duration(minutes: 30 - now.minute));
    if (now.minute < 45) return now.add(Duration(minutes: 45 - now.minute));
    return now.add(Duration(minutes: 60 - now.minute));
  }
}

final Time time = Time();
