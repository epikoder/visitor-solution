import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/utils/size.dart';
import 'package:visitor_solution/views/shared/fragment.nav.shared.dart';

class FragmentNavView extends StatelessWidget {
  const FragmentNavView({
    super.key,
    required this.nav,
    required this.body,
  });

  final List<NavViewButton> nav;
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return <Widget>[
      nav.toColumn().constrained(width: fragmentNavWidth).border(right: .3),
      body
      // .expanded(flex: 1),
    ].toRow();
  }
}

class NavViewButton extends StatelessWidget {
  const NavViewButton({
    super.key,
    required this.text,
    this.onTap,
  });
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FragmentNavViewController>();

    return Obx(
      () => [
        Styled.text(text).textColor(controller.currentRoute.value == text
            ? Colors.white
            : Colors.black87)
      ]
          .toRow()
          .padding(vertical: 15, horizontal: 20)
          .backgroundColor(controller.currentRoute.value == text
              ? Colors.blue.shade500
              : Colors.transparent)
          .border(bottom: .3, color: Colors.grey.shade800)
          .ripple()
          .gestures(
        onTap: () {
          controller.currentRoute.value = text;
          if (onTap != null) onTap!();
        },
      ),
    );
  }
}
