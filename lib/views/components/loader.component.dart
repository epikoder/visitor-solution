import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/utils/assets.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return [
      Styled.widget()
          .backgroundColor(Colors.black12)
          .width(double.infinity)
          .height(double.infinity),
      Image.asset(
        Assets.logo,
        height: 60,
        width: 60,
      )
          .backgroundColor(Colors.white)
          .clipRRect(all: 100)
          .padding(all: 5)
          .backgroundColor(Colors.white)
          .clipRRect(all: 100)
          .center(),
      const CircularProgressIndicator(
        strokeWidth: 1.5,
      ).width(62).height(62).center(),
    ].toStack();
  }
}
