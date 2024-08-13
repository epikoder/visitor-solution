import 'package:flutter/foundation.dart';

void logWarn(dynamic value) => logger(value, label: 'Warning');
void logError(dynamic value, {dynamic stackTrace}) => logger("""
$value
${stackTrace != null ? '------------------------------' : ""}
$stackTrace
""", label: 'Error');
void logger(dynamic value, {String? label}) {
  if (kDebugMode) {
    print(
        "------------------------ ${label ?? 'DEBUG'} ------------------------");
    print(value);
    print("--------------------------------------------------------");
  }
}
