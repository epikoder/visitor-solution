import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/utils/size.dart';
import 'package:visitor_solution/views/shared/app.shared.dart';

class NavbarButtonComponent extends StatelessWidget {
  const NavbarButtonComponent({
    super.key,
    required this.route,
    required this.icon,
    this.onTap,
  });

  final AppViewRoute route;
  final IconData icon;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final appViewController = Get.find<AppViewController>();

    return Obx(
      () => [
        Styled.icon(icon)
            .iconColor(appViewController.currentRoute.value == route
                ? Colors.white
                : Colors.black87)
            .iconSize(22),
      ]
          .toRow(
            separator: const SizedBox(
              width: 15,
            ),
          )
          .width(double.infinity)
          .paddingSymmetric(vertical: 5, horizontal: 10)
          .ripple(
            hoverColor: Colors.blue.shade400,
          )
          .gestures(
            onTap: () {
              if (onTap != null) onTap!();
              appViewController.currentRoute.value = route;
            },
          )
          .decorated(
            color: appViewController.currentRoute.value == route
                ? Colors.blue.shade500
                : Colors.white,
          )
          .clipRRect(all: 5)
          .constrained(maxWidth: sideNavWidth.toDouble()),
    );
  }
}
