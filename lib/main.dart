import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:visitor_solution/routes.dart';
import 'package:visitor_solution/services/navigator.dart';
import 'package:visitor_solution/utils/camera_delegate/platform_delegate.dart';
import 'package:visitor_solution/utils/qr.dart';
import 'package:visitor_solution/utils/theme.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpCameraDelegate();

  await WindowManager.instance.ensureInitialized();
  WindowManager.instance.setMinimumSize(const Size(800, 500));
  WindowManager.instance.setTitle("Visitor Solution");
  await QR.instance.ensureInitialized();
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
