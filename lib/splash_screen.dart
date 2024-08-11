import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/utils/assets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Get.offNamed("/home");
      }
    });
    return Styled.widget(
      child: SafeArea(
        child: Scaffold(
          body: Image.asset(Assets.logo).constrained(maxHeight: 100).center(),
        ),
      ),
    );
  }
}
