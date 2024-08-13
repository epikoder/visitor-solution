import 'package:flutter/widgets.dart';

abstract class NavigatorService {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static bool get isMounted => navigatorKey.currentContext != null
      ? navigatorKey.currentContext!.mounted
      : false;
}
