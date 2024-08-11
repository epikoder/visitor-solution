import 'package:flutter/material.dart';
import 'package:visitor_solution/splash_screen.dart';
import 'package:visitor_solution/views/app.view.dart';

final Map<String, WidgetBuilder> appRoutes = {
  "/": (_) => const SplashScreen(),
  "/home": (_) => AppView(),
};
