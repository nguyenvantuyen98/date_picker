class Time {
  DateTime now = DateTime.now();
  Map getDayList() {
    List<String> dayStringList = [
      'Now',
      'Today',
      'Tomorrow',
    ];
    List<int> linkToMonthList = [
      now.month,
      now.month,
      now.add(Duration(days: 1)).month,
    ];

    Duration difference =
        DateTime(now.year + 1, now.month, now.day).difference(now);
    for (int i = 2; i <= difference.inDays; i++) {
      DateTime nextDay = now.add(Duration(days: i));
      dayStringList.add(formatDay(nextDay));
      linkToMonthList.add(nextDay.month);
    }
    List<String> monthStringList = [];
    List<int> linkToDayList = [];
    for (int month in linkToMonthList) {
      String monthString = getMonth(month);
      if (!monthStringList.contains(monthString)) {
        monthStringList.add(monthString);
        linkToDayList.add(month);
      }
    }

    return {
      'dayStringList': dayStringList,
      'linkToMonthList': linkToMonthList,
      'monthStringList': monthStringList + [monthStringList[0]],
      'linkToDayList': linkToDayList + [linkToDayList[0]],
    };
  }

  List<String> getHourList([bool isNewDay = false]) {
    List<String> hourStringList;

    DateTime roundedTime = isNewDay
        ? DateTime(now.year, now.month, now.day, 0, 0)
        : roundTimeEach15Minutes();
    if (roundedTime.hour < 12)
      hourStringList = [
        'Anytime',
        'Morning',
        'Afternoon',
        'Evening',
        'Night',
      ];
    else if (roundedTime.hour < 17)
      hourStringList = [
        'Anytime',
        'Afternoon',
        'Evening',
        'Night',
      ];
    else if (roundedTime.hour < 21)
      hourStringList = [
        'Anytime',
        'Evening',
        'Night',
      ];
    else
      hourStringList = [
        'Anytime',
        'Night',
      ];

    while (roundedTime.day == now.day) {
      hourStringList.add(formatTime(roundedTime));
      roundedTime = roundedTime.add(Duration(minutes: 15));
    }
    return hourStringList;
  }

  String formatDay(DateTime dateTime) {
    return '${getWeekDay(dateTime)}${dateTime.day}';
  }

  String formatTime(DateTime dateTime) {
    String hours = '${dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}';
    String minutes = dateTime.minute != 0
        ? ':${dateTime.minute.toString().padLeft(2, '0')}'
        : '';
    return '$hours$minutes${dateTime.hour < 12 ? 'am' : 'pm'}';
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

  String getMonth(int month) {
    if (month == 1) return 'Jan';
    if (month == 2) return 'Feb';
    if (month == 3) return 'Mar';
    if (month == 4) return 'Apr';
    if (month == 5) return 'May';
    if (month == 6) return 'Jun';
    if (month == 7) return 'Jul';
    if (month == 8) return 'Aug';
    if (month == 9) return 'Sep';
    if (month == 10) return 'Oct';
    if (month == 11) return 'Nov';
    if (month == 12) return 'Dec';
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

  static List<String> hoursList = [
    "1hr",
    "2hrs",
    "3hrs",
    "4hrs",
    "5hrs",
    "6hrs",
    "7hrs",
    "8hrs"
  ];

  bool checkDate(String startMonth, String startDay, String startHour,
      String endMonth, String endDay, String endHour) {}
}
