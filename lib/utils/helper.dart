import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:visitor_solution/services/navigator.dart';

String datetimeToString(DateTime date, {bool? showTime}) {
  return "${date.year}/${date.month > 9 ? date.month : '0${date.month}'}/${date.day > 9 ? date.day : '0${date.day}'} ${showTime != null && showTime ? TimeOfDay.fromDateTime(date).format(NavigatorService.navigatorKey.currentContext!) : ""}";
}

String timeOfDayTo24String(TimeOfDay? time) {
  return time != null
      ? "${time.hour > 9 ? time.hour : '0${time.hour}'}:${time.minute > 9 ? time.minute : '0${time.minute}'}:00"
      : "";
}

String bytesToString(Uint8List bytes) {
  StringBuffer buffer = StringBuffer();
  for (int i = 0; i < bytes.length;) {
    int firstWord = (bytes[i] << 8) + bytes[i + 1];
    if (0xD800 <= firstWord && firstWord <= 0xDBFF) {
      int secondWord = (bytes[i + 2] << 8) + bytes[i + 3];
      buffer.writeCharCode(
          ((firstWord - 0xD800) << 10) + (secondWord - 0xDC00) + 0x10000);
      i += 4;
    } else {
      buffer.writeCharCode(firstWord);
      i += 2;
    }
  }
  return buffer.toString();
}

String generateRandomString(int length) {
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Random random = Random();
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}
