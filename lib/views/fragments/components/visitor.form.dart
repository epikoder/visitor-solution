import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/models/gender.model.dart';
import 'package:visitor_solution/models/purpose.model.dart';
import 'package:visitor_solution/utils/client.dart';
import 'package:visitor_solution/utils/constant.dart';
import 'package:visitor_solution/utils/helper.dart';
import 'package:visitor_solution/utils/logger.dart';
import 'package:visitor_solution/utils/storage.dart';
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
  final Rx<XFile?> image = Rx(null);
  final Rx<TimeOfDay?> time = Rx(null);

  final formKey = GlobalKey<FormState>();

  final appViewController = Get.find<AppViewController>();
  Future<void> submit(void Function(String) onSubmit) async {
    if (!formKey.currentState!.validate() || image.value == null) return;
    appViewController.setIsLoading();

    try {
      var request = http.MultipartRequest("POST", Uri.parse(fileServerURL()));
      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          await image.value!.readAsBytes(),
          filename: "upload.png",
          contentType: MediaType('multipart', 'form-data'),
        ),
      );

      final resp = await request.send();
      if (resp.statusCode != 200) {
        Get.showSnackbar(const GetSnackBar(
          title: "Error",
          message: "Something went wrong while saving image",
          duration: Duration(seconds: 1),
        ));
        throw Exception("file server error");
      }
      final r = await http.Response.fromStream(resp);

      var vid =
          "${generateRandomString(3)}-${phone.text.trim().startsWith("234") ? phone.text.trim().replaceFirst("234", "") : phone.text.trim().replaceFirst("0", "")}";
      final data = {
        "vid": vid,
        "fname": fname.text.trim(),
        "lname": lname.text.trim(),
        "phone": phone.text.trim(),
        "gender": gender.value.string.toLowerCase(),
        "department": department.text.trim(),
        "purpose": purpose.value.string.toLowerCase(),
        "date": datetimeToString(date.value),
        "time": time.value?.toString(),
        "photo": r.body,
      };
      await Client.instance.from("visitors").insert(data);
      onSubmit(vid);
    } catch (e, trace) {
      logError(e, stackTrace: trace);
    }
    appViewController.setIsNotLoading();
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
  VisitorForm({
    super.key,
    required this.onSubmit,
  });
  final void Function(String) onSubmit;
  final controller = _Controller();

  @override
  Widget build(BuildContext context) {
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
          file: controller.image,
          label: "Visitor Photo",
          isRequired: true,
        ),
        const SizedBox(
          height: 20,
        ),
        StyledButton(
          text: "SUBMIT",
          onTap: () => controller.submit(onSubmit),
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
