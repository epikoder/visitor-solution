import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visitor_solution/views/components/fragment.component.dart';
import 'package:visitor_solution/views/components/fragment.appbar.component.dart';
import 'package:visitor_solution/views/components/fragment.nav.view.dart';
import 'package:visitor_solution/views/fragments/navigations/about.fragment.dart';
import 'package:visitor_solution/views/fragments/navigations/configuration.fragment.dart';
import 'package:visitor_solution/views/shared/fragment.nav.shared.dart';

class SettingFragment extends StatelessWidget {
  SettingFragment({super.key});

  final routes = ["Configuration", "About"];
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FragmentNavViewController(routes.first));

    return Fragment(
      appBar: const FragmentAppBar(
        title: "Settings",
      ),
      body: FragmentNavView(
        nav: routes.map((route) => NavViewButton(text: route)).toList(),
        body: Obx(() {
          switch (controller.currentRoute.value) {
            case "About":
              return const AboutFragment();
            default:
              return const ConfigurationFragment();
          }
        }),
      ),
    );
  }
}
