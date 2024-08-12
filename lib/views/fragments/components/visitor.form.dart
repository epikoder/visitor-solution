import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/models/gender.model.dart';
import 'package:visitor_solution/models/purpose.model.dart';
import 'package:visitor_solution/views/components/button.component.dart';
import 'package:visitor_solution/views/components/input.component.dart';
import 'package:visitor_solution/views/shared/app.shared.dart';

class _Controller extends GetxController {
  final TextEditingController fname = TextEditingController();
  final TextEditingController lname = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController department = TextEditingController();
  final gender = Gender.male.obs;
  final purpose = Purpose.appointment.obs;
  final date = DateTime.now().obs;
  final Rx<Uint8List?> image = Rx(null);
  final Rx<TimeOfDay?> time = Rx(null);

  final formKey = GlobalKey<FormState>();

  final appViewController = Get.find<AppViewController>();
  Future<void> submit() async {
    if (!formKey.currentState!.validate() || image.value == null) return;
    appViewController.setIsLoading();
    Future.delayed(
        const Duration(seconds: 3), appViewController.setIsNotLoading);
  }

  @override
  void dispose() {
    fname.dispose();
    lname.dispose();
    phone.dispose();
    department.dispose();
    gender.close();
    purpose.close();
    date.close();
    image.close();
    time.close();
    super.dispose();
  }
}

class VisitorForm extends StatelessWidget {
  const VisitorForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = _Controller();

    return Form(
      key: controller.formKey,
      child: <Widget>[
        TextInput(
          label: "First Name",
          controller: controller.fname,
          isRequired: true,
        ),
        TextInput(
          label: "Last Name",
          controller: controller.lname,
          isRequired: true,
        ),
        RxDropdown(
          label: "Gender",
          items: Gender.values,
          display: (gender) => Styled.text(gender.string).fontSize(14),
          value: controller.gender,
        ),
        TextInput(
          label: "Phone",
          controller: controller.phone,
          isRequired: true,
          validator: (v) {
            return RegExp(r'^(234|0)([789])([01])[0-9]{8}$').hasMatch(v ?? "")
                ? null
                : "phone is invalid";
          },
        ),
        TextInput(
          label: "Department",
          controller: controller.department,
          isRequired: true,
        ),
        RxDropdown(
          label: "Purpose of visit",
          items: Purpose.values,
          display: (purpose) => Styled.text(purpose.string).fontSize(14),
          value: controller.purpose,
        ),
        DateTimePicker(
          date: controller.date,
          time: controller.time,
        ),
        RxImagePicker(
          bytes: controller.image,
          label: "Visitor Photo",
          isRequired: true,
        ),
        const SizedBox(
          height: 20,
        ),
        StyledButton(
          text: "submit",
          onTap: controller.submit,
        ),
      ].toColumn(
        mainAxisAlignment: MainAxisAlignment.center,
        separator: const SizedBox(
          height: 20,
        ),
      ),
    ).padding(vertical: 20, horizontal: 20).scrollable().expanded(flex: 1);
  }
}
