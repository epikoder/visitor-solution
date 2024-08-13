import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/views/components/loader.component.dart';
import 'package:visitor_solution/views/components/navbar.button.component.dart';
import 'package:visitor_solution/views/fragments/dashboard.fragment.dart';
import 'package:visitor_solution/views/fragments/scan.fragment.dart';
import 'package:visitor_solution/views/fragments/settings.fragment.dart';
import 'package:visitor_solution/views/fragments/visitors.fragment.dart';
import 'package:visitor_solution/views/shared/app.shared.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppViewController());

    return SafeArea(
      child: Scaffold(
        body: [
          [
            [
              [
                const NavbarButtonComponent(
                  route: AppViewRoute.dashboard,
                  icon: Icons.home_outlined,
                ),
                const NavbarButtonComponent(
                  route: AppViewRoute.visitors,
                  icon: Icons.people_outline,
                ),
              ].toColumn(
                separator: const SizedBox(
                  height: 10,
                ),
              ),
              const NavbarButtonComponent(
                route: AppViewRoute.settings,
                icon: Icons.settings,
              ),
            ]
                .toColumn(
                  separator: const SizedBox(
                    height: 40,
                  ),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                )
                .paddingSymmetric(vertical: 20, horizontal: 10)
                .border(right: 1, color: Colors.grey.shade300),
            Obx(() {
              switch (controller.currentRoute.value) {
                case AppViewRoute.visitors:
                  return const VisitorsFragment();
                case AppViewRoute.settings:
                  return SettingFragment();
                default:
                  return const DashboardFragment();
              }
            }),
          ].toRow(),
          Obx(
            () => Visibility(
              visible: controller.loading,
              child: const Loader(),
            ),
          )
        ].toStack(),
      ),
    );
  }
}
