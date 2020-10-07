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

  int decodeMonth(String month) {
    if (month == 'Jan') return 1;
    if (month == 'Feb') return 2;
    if (month == 'Mar') return 3;
    if (month == 'Apr') return 4;
    if (month == 'May') return 5;
    if (month == 'Jun') return 6;
    if (month == 'Jul') return 7;
    if (month == 'Aug') return 8;
    if (month == 'Sep') return 9;
    if (month == 'Oct') return 10;
    if (month == 'Nov') return 11;
    if (month == 'Dec') return 12;
    return 0;
  }

  int decodeDay(String day) {
    if (day == 'Now' || day == 'Today') return now.day;
    if (day == 'Tomorrow') return now.day + 1;
    return int.parse(day.substring(2));
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

  List<int> decodeHour(String hour) {
    if (hour == 'Anytime') {
      return [0, 0];
    }
    if (hour == 'Morning') {
      return [6, 0];
    }
    if (hour == 'Afternoon') {
      return [13, 0];
    }
    if (hour == 'Evening') {
      return [17, 0];
    }
    if (hour == 'Night') {
      return [21, 0];
    }
    bool isPM = hour[hour.length - 2] == 'p';
    hour = hour.substring(0, hour.length - 2);
    print('hour = $hour ans isPM = $isPM');
    List<String> split = hour.contains(':') ? hour.split(':') : [hour[0], '0'];
    if (split[0] == '12') isPM = false;
    print('split = $split');
    return [
      isPM ? int.parse(split[0]) + 12 : int.parse(split[0]),
      int.parse(split[1])
    ];
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
      String endMonth, String endDay, String endHour) {
    print('startMonth: $startMonth');
    print('startDay: $startDay');
    print('startHour: $startHour');
    print('endMonth: $endMonth');
    print('endDay: $endDay');
    print('endHour: $endHour');
    if (startHour == 'Now' || endHour == '') {
      print("startHour == 'Now' || endHour == ''");
      return true;
    }

    List<int> startHourDecode = decodeHour(startHour);
    List<int> endHourDecode = decodeHour(endHour);
    int startHourInt = startHourDecode[0];
    print('startHour after decode = $startHourInt');
    int startMinuteInt = startHourDecode[1];
    int endHourInt = endHourDecode[0];
    print('endHour after decode  = $endHourInt');
    int endMinuteInt = endHourDecode[1];
    int startDayInt = decodeDay(startDay);
    int endDayInt = decodeDay(endDay);
    int startMonthInt = decodeMonth(startMonth);
    int endMonthInt = decodeMonth(endMonth);
    int startYear = now.year;
    int endYear = now.year;
    if (startMonthInt == now.month && startDayInt < now.day) startYear++;
    if (endMonthInt == now.month && endDayInt < now.day) endYear++;
    print('DateTimeCompare');
    return DateTime(
            startYear, startMonthInt, startDayInt, startHourInt, startMinuteInt)
        .isBefore(DateTime(
            endYear, endMonthInt, endDayInt, endHourInt, endMinuteInt));
  }
}
