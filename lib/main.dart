import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:visitor_solution/routes.dart';
import 'package:visitor_solution/services/navigator.dart';
import 'package:visitor_solution/utils/camera_delegate.dart';
import 'package:visitor_solution/utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpCameraDelegate();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Visitor Solution",
      routes: appRoutes,
      initialRoute: "/",
      theme: themeData,
      navigatorKey: NavigatorService.navigatorKey,
    );
  }
}
