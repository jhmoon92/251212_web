import 'dart:core';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:ui' as ui;


DateTime mostRecentSunday(DateTime date) => DateTime(date.year, date.month, date.day - date.weekday % 7);
DateTime mostRecentMonday(DateTime date) => DateTime(date.year, date.month, date.day - (date.weekday + 6) % 7);

DateTime todayDate() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

String todayDateString() {
  return todayDate().toString();
}

bool isSameDayAsToday(DateTime date) {
  DateTime today = DateTime.now();
  return date.year == today.year && date.month == today.month && date.day == today.day;
}

String conv24To12HTime(String time) {
  String time12h = "";
  int hour = int.parse(time.substring(0, 2));
  if (hour > 12) {
    time12h = (hour - 12).toString().padLeft(2, "0") + time.substring(2) + " " + "PM"; //"common_pm".tr(); //TODO:
  } else if (hour == 12) {
    time12h = time + " " + "PM"; //"common_pm".tr(); //TODO:
  } else {
    time12h = time + " " + "AM"; //"common_am".tr(); //TODO:
  }

  return time12h;
}
String convertDateTimeAMPM(DateTime time) {
  int hour = time.hour;

  if (hour < 12) {
    return "${hour}AM";
  } else if (hour == 12) {
    return "12PM";
  } else {
    return "${hour - 12}PM";
  }
}

String convertHourAMPM(int hour) {
  if (hour < 12) {
    return "${hour}AM";
  } else if (hour == 12) {
    return "12PM";
  } else {
    return "${hour - 12}PM";
  }
}

eFormat(DateTime dt) {
  String str;
  str = intl.DateFormat.yMMMMd('en_US').format(dt);

  return str;
}

String getDateTodayFormat(DateTime date, {bool week = false}) {
  DateTime now = DateTime.now();
  int diff = DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
  switch (diff) {
    case 0:
      return "common_today".tr();
    case -1:
      return "common_yesterday".tr();
    default:
      break;
  }
  if (week)
    return "common_week_${date.weekday - 1}".tr() + ',' + ' ' + getDateShortFormat(date);
  else
    return getDateShortFormat(date);
}

String getDateShortFormat(DateTime dt) {
  String str;
  str = intl.DateFormat.MMMMd('en_US').format(dt);

  return str;
}

String convDateTimeToDate(DateTime dt) {
  return intl.DateFormat('yyyy-MM-dd', 'en_US').format(dt);
}

DateTime convTimeToDateTime(String time) {
  final List<String> splitted = time.split(':');

  DateTime dt = DateTime(2022, 2, 10, int.parse(splitted[0]), int.parse(splitted[1]), 0);
  return dt;
}

int getTimeSlotIndexFromTime(String time, int slotSize, [bool roundUpExceptZero = false]) {
  int index = 0;
  DateTime dt = convTimeToDateTime(time);

  index += ((dt.hour * 60 + dt.minute) ~/ slotSize);

  if (roundUpExceptZero && (dt.minute % slotSize) > 0) {
    // example) 1:00 -> index = (1*60+0) ~/ 10 = 6 + 0 = 6
    // example) 1:01 -> index = (1*60+1) ~/ 10 = 6 + 1 = 7
    // example) 1:09 -> index = (1*60+9) ~/ 10 = 6 + 1 = 7
    // example) 1:10 -> index = (1*60+10) ~/ 10 = 7 + 0 = 7
    index++;
  }

  return index;
}

TimeOfDay getTimeOfDay(String time) {
  List<String> t = time.split(":");
  if (t.length == 3) {
    return TimeOfDay(hour: int.parse(t[0]), minute: int.parse(t[1]));
  } else {
    return TimeOfDay(hour: int.parse(t[0]), minute: int.parse(t[1]));
  }
}

String getFormatTime(TimeOfDay time, [bool isData = false]) {
  String hour = "";
  String minute = "";
  if (isData) {
    if (time.hour < 10) {
      hour = "0${time.hour}";
    } else {
      hour = "${time.hour}";
    }

    if (time.minute < 10) {
      minute = "0${time.minute}";
    } else {
      minute = "${time.minute}";
    }

    return '$hour:$minute:00';
  } else {
    if (time.minute < 10) {
      minute = "0${time.minute}";
    } else {
      minute = "${time.minute}";
    }

    if (time.hour > 12) {
      hour = "${time.hour - 12}";
    } else {
      hour = "${time.hour}";
    }

    return '$hour:$minute ${time.period.toString().split('.')[1]}';
  }
}

String getTimeFromIntMin(int minData) {
  int hour = minData ~/ 60;
  int minute = minData % 60;
  String hourString = "";
  String minuteString = "";

  if (minute < 10) {
    minuteString = "0$minute";
  } else {
    minuteString = "$minute";
  }

  if (hour > 12) {
    hourString = "${hour - 12}";
  } else {
    hourString = "$hour";
  }

  return '$hourString:$minuteString';
}

String getAMPMTimeFromIntMin(int minData) {
  int hour = minData ~/ 60;
  int minute = minData % 60;
  String hourString = "";
  String minuteString = "";
  bool isAM = true;

  if (minute < 10) {
    minuteString = "0$minute";
  } else {
    minuteString = "$minute";
  }

  if (hour > 12) {
    isAM = false;
    hourString = "${hour - 12}";
  } else {
    hourString = "$hour";
  }
  if(hour == 12 && (minuteString.isNotEmpty || minuteString != "00")) isAM = false;  // 12:39 PM (not AM)

  if (isAM) {
    return '$hourString:$minuteString' "AM";
  } else {
    return '$hourString:$minuteString' "PM";
  }
}

Widget getHoursMins(int minData, double padding, TextStyle timeStyle, TextStyle hourStyle) {
  int hour = minData ~/ 60;
  int minute = minData % 60;
  return Row(
    children: [
      Text(hour.toString(), style: timeStyle),
      Padding(padding: EdgeInsets.only(top: padding), child: Text(" ${"common_hours_small".tr()} ", style: hourStyle)),
      Text(minute.toString(), style: timeStyle),
      Padding(padding: EdgeInsets.only(top: padding), child: Text(" ${"common_mins".tr()}", style: hourStyle)),
    ],
  );
}

String getConnectedTime(DateTime onlineTime) {
  if (getDateTodayFormat(onlineTime) == "common_today".tr()) {
    return DateFormat('hh:mm aa,', 'en_US').format(onlineTime) + "common_today".tr();
  } else if (getDateTodayFormat(onlineTime) == "common_yesterday".tr()) {
    return DateFormat('hh:mm aa,', 'en_US').format(onlineTime) + "common_yesterday".tr();
  } else {
    return DateFormat('hh:mm aa, MMM dd', 'en_US').format(onlineTime);
  }
}

String getConnectedTimeString(String onlineTime) {
  if (onlineTime.isEmpty) return onlineTime;
  if (getDateTodayFormat(DateTime.parse(onlineTime)) == "common_today".tr()) {
    return DateFormat('hh:mm aa,', 'en_US').format(DateTime.parse(onlineTime)) + "common_today".tr();
  } else if (getDateTodayFormat(DateTime.parse(onlineTime)) == "common_yesterday".tr()) {
    return DateFormat('hh:mm aa,', 'en_US').format(DateTime.parse(onlineTime)) + "common_yesterday".tr();
  } else {
    return DateFormat('hh:mm aa, MMM dd', 'en_US').format(DateTime.parse(onlineTime));
  }
}


String convDateTimeToTimeAM(DateTime dt) {
  return intl.DateFormat.jm('en_US').format(dt);
}

int getWeekIndex(DateTime t) {
  return t.weekday == 7 ? 0 : t.weekday;
}


DateTime getDateTime(String t) {
  List<String> split = t.split(' ');
  if (split.length > 1) {
    final List<String> splitDate = split[0].split('-');
    final List<String> splitTime = split[1].split(':');
    String date = splitDate[0] + splitDate[1] + splitDate[2];
    String time = splitTime[0] + splitTime[1] + splitTime[2];
    return DateTime.parse('${date}T$time');
  }
  return DateTime.now();
}


int subtractNowMin(String t) {
  return DateTime.now().difference(getDateTime(t)).inSeconds;
}

int pageCount(int data) {
  return ((data / 5).ceil());
}

bool isMaxLineCheck(double width, String text, TextStyle style) {
  var checkTextMaxLine = TextPainter(
    maxLines: 1,
    textAlign: TextAlign.left,
    textDirection: ui.TextDirection.ltr,
    text: TextSpan(text: text, style: style),
  )..layout(minWidth: 0, maxWidth: width);

  return checkTextMaxLine.didExceedMaxLines;
}

extension DateTimeExtension on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

String fstr(String string, List<String> params) {
  String result = string;

  for (int i = 0; i < params.length; i++) {
    result = result.replaceAll('{${i + 1}}', params[i]);
  }

  return result;
}

DateTime? ageToBirthDay(String? birth_date, int? age) {
  if (birth_date != null && birth_date.isNotEmpty) {
    return DateTime.parse(birth_date);
  }
  return null;
  // } else {
  //   age ??= defaultAge;
  //   DateTime currentDate = DateTime.now();
  //
  //   int birthYear = currentDate.year - age + 1;
  //   return DateTime(birthYear, 1, 1);
  // }
}

int birthDayToAge(DateTime? birthDate) {
  if(birthDate == null) return -1;

  DateTime currentDate = DateTime.now();

  int age = currentDate.year - birthDate.year + 1;

  // Check if the birthday has occurred this year already
  if (currentDate.month < birthDate.month) {
    age--;
  } else if (currentDate.month == birthDate.month && currentDate.day < birthDate.day) {
    age--;
  }

  // Determine age group
  if (age >= 0 && age < 10) {
    return 1;
  } else if (age >= 10 && age < 20) {
    return 10;
  } else if (age >= 20 && age < 30) {
    return 20;
  } else if (age >= 30 && age < 40) {
    return 30;
  } else if (age >= 40 && age < 50) {
    return 40;
  } else if (age >= 50 && age < 60) {
    return 50;
  } else if (age >= 60 && age < 70) {
    return 60;
  } else if (age >= 70 && age < 80) {
    return 70;
  } else {
    // Handle other cases if needed
    return 0; // or throw an exception or handle it differently
  }
}

int getRandomInt(int max) {
  Random random = Random();
  return random.nextInt(max);
}

String getTruncatedText(String text, TextStyle style, double maxWidth, BuildContext context) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: ui.TextDirection.ltr,
  );

  textPainter.layout(maxWidth: maxWidth);

  if (textPainter.didExceedMaxLines) {
    String truncatedText = text;
    while (textPainter.didExceedMaxLines) {
      truncatedText = truncatedText.substring(0, truncatedText.length - 1);
      textPainter.text = TextSpan(text: '$truncatedText...', style: style);
      textPainter.layout(maxWidth: maxWidth);
    }
    return '$truncatedText...';
  } else {
    return text;
  }
}

double stringWidth(String text, TextStyle style) {
  var textPainter = TextPainter(
    maxLines: 1,
    textAlign: TextAlign.left,
    textDirection: ui.TextDirection.ltr,
    text: TextSpan(text: text, style: style),
  )..layout(minWidth: 0, maxWidth: double.infinity);

  return textPainter.size.width;
}

void logCurrentFunction(String message) {
  // Capture the current stack trace
  final stackTrace = StackTrace.current;

  // Extract the first relevant frame (skip this function call itself)
  final stackFrames = stackTrace.toString().split('\n');
  if (stackFrames.length > 1) {
    final functionDetails = stackFrames[1].trim(); // Extract the caller's details
    debugPrint('$functionDetails: $message');
  } else {
    debugPrint('Unknown location: $message');
  }
}

String extractValue(String response, String key, [bool isName = false]) {
  RegExp regex = isName ? RegExp(r'(\w+)=([^,\s]+)') : RegExp(r'(\w+)=([^,)\s]+)'); // 괄호 및 공백 제외한 값만 추출
  for (Match match in regex.allMatches(response)) {
    if (match.group(1) == key) {
      return match.group(2) ?? "";
    }
  }
  return "";
}

bool isDialogShowing(BuildContext context) {
  return ModalRoute.of(context) is DialogRoute;
}

Map<String, String> parsingQRCode(String qrCode ) {
  String serial = "";
  String mac = "";

  List<String> routerInfo = qrCode.split(";");
  if(routerInfo[2].startsWith("SN:")) {
    serial = routerInfo[2].replaceFirst("SN:", "");
  }
  if(routerInfo[3].startsWith("MAC:")) {
    mac = routerInfo[3].replaceFirst("MAC:", "");
  }
  return {"serial": serial, "mac": mac};
}

//MODEL:HNS-200;POD:1;SN:3030F9065264;MAC:3030F9065264;
String makeQRCode(String model, String serial, String mac) {
  String MAC = mac;
  if(MAC.contains(":")) {
    MAC = MAC.replaceAll(":", "");
  }
  return 'MODEL:$model;POD:1;SN:$serial;MAC:$MAC';
}

String formatMinutesToTimeAgo(int totalMinutes) {
  // 0분 이하일 경우 처리
  if (totalMinutes < 1) {
    return '0m ago';
  }

  const int minutesInHour = 60;
  const int minutesInDay = 24 * minutesInHour; // 1440분

  // 1. 일(d) 계산
  int days = totalMinutes ~/ minutesInDay;
  int remainingMinutes = totalMinutes % minutesInDay;

  // 2. 시(h) 계산
  int hours = remainingMinutes ~/ minutesInHour;

  // 3. 분(m) 계산
  int minutes = remainingMinutes % minutesInHour;

  List<String> parts = [];

  // 일(d)이 0보다 클 경우 추가
  if (days > 0) {
    parts.add('${days}d');
  }

  // 시(h)가 0보다 클 경우 추가
  if (hours > 0) {
    parts.add('${hours}h');
  }

  // 분(m)이 0보다 클 경우 추가
  // 만약 전체 시간이 1시간 미만일 경우 (days=0, hours=0)에도 분을 표시해야 합니다.
  // 이 로직은 days > 0 또는 hours > 0 인 경우, minutes가 0이면 표시하지 않습니다.
  if (minutes > 0) {
    parts.add('${minutes}m');
  }

  // 예외 처리: 전체 시간이 1시간의 배수라서 minutes가 0이고 days와 hours만 있는 경우
  // 예: 60분 -> 1h (parts는 ['1h']가 됨)
  // 예: 1440분 -> 1d (parts는 ['1d']가 됨)
  // 이는 요청하신 예시 포맷에 부합하므로 별도의 예외 처리는 필요 없습니다.

  return '${parts.join(' ')} ago';
}
