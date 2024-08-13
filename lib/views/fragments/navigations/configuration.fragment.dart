import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/utils/constant.dart';
import 'package:visitor_solution/utils/size.dart';
import 'package:visitor_solution/utils/storage.dart';
import 'package:visitor_solution/views/components/button.component.dart';
import 'package:visitor_solution/views/components/input.component.dart';

class ConfigurationFragment extends StatelessWidget {
  const ConfigurationFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      const XSet(
        text: "Posgrest",
        skey: postgRestKey,
        placeholder: defaultPostgRestUrl,
        message: "Set Url of postgrest service defaults to \n$defaultPostgRestUrl",
      ),
      const XSet(
        text: "FileServer",
        skey: fileServerKey,
        placeholder: defaultFileServerUrl,
        message: "Set url of Fileserver service dafaults to \n$defaultFileServerUrl",
      ),
      [
        Styled.icon(Icons.info_outline_rounded).iconSize(16),
        Styled.text("changes will be applied on next app restart")
            .fontSize(12),
      ].toRow(),
    ]
        .toColumn(
          separator: const SizedBox(
            height: 40,
          ),
        )
        .padding(vertical: 20, horizontal: 10);
  }
}

class XSet extends StatelessWidget {
  const XSet({
    super.key,
    required this.text,
    required this.skey,
    required this.placeholder,
    this.onUpdate,
    this.message,
  });

  final String text;
  final String skey;
  final String placeholder;
  final String? message;
  final Function(String?)? onUpdate;

  @override
  Widget build(BuildContext context) {
    final controller =
        TextEditingController(text: Storage.instance.read(skey) ?? "");
    return <Widget>[
      [
        Styled.text(text.toUpperCase()).fontWeight(FontWeight.w600),
        if (message != null) Styled.text(message!).fontSize(12).width(300),
      ].toColumn(
        separator: const SizedBox(
          height: 5,
        ),
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      [
        TextAreaInput(
          controller: controller,
          placeholder: placeholder,
        ),
        [
          StyledButton(
            text: "Reset Default",
            horizontalPadding: 20,
            verticalPadding: 5,
            color: Colors.blue.shade500,
            mainAxisSize: MainAxisSize.min,
            onTap: () {
              controller.text = "";
              Storage.instance.remove(skey);
              if (onUpdate != null) {
                onUpdate!(null);
              }
              Get.snackbar(
                "Success",
                "Updated successfully",
                duration: const Duration(seconds: 2),
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
          StyledButton(
            text: "Save",
            horizontalPadding: 20,
            verticalPadding: 5,
            color: Colors.green.shade500,
            mainAxisSize: MainAxisSize.min,
            onTap: () {
              final t = controller.text;
              Storage.instance.write(skey, t);
              if (onUpdate != null) {
                onUpdate!(t);
              }
              Get.snackbar(
                "Success",
                "Updated successfully",
                duration: const Duration(seconds: 2),
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          )
        ].toRow(
          mainAxisAlignment: MainAxisAlignment.end,
          separator: const SizedBox(
            width: 40,
          ),
        ),
      ]
          .toColumn(
              separator: const SizedBox(
            height: 5,
          ))
          .constrained(maxWidth: 400),
    ]
        .toRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .constrained(
            maxWidth: MediaQuery.of(context).size.width -
                fragmentNavWidth -
                sideNavWidth -
                60);
  }
}
