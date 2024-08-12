import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/views/components/button.component.dart';

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.controller,
    required this.label,
    this.isRequired,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool? isRequired;
  final String? Function(String?)? validator;

  String? _validator(String? text) {
    if (text == null || text.isEmpty) return "field is required";
    return validator != null ? validator!(text) : null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.black12,
            width: .5,
          ),
        ),
        label: Styled.text(label),
        labelStyle: const TextStyle(fontSize: 14),
      ),
      style: const TextStyle(fontSize: 14),
      maxLines: 1,
      validator: _validator,
    );
  }
}

class RxDropdown<T> extends StatelessWidget {
  const RxDropdown({
    super.key,
    required this.items,
    required this.display,
    required this.value,
    required this.label,
  });

  final List<T> items;
  final Widget Function(T) display;
  final Rx<T?> value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButtonHideUnderline(
        child: <Widget>[
          DropdownButton(
            value: value.value,
            items: items
                .map(
                  (v) => DropdownMenuItem(
                    value: v,
                    child: display(v),
                  ),
                )
                .toList(),
            onChanged: (dynamic value) => this.value.value = value,
          ).paddingSymmetric(horizontal: 10).width(double.infinity).decorated(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black87, width: .5),
              ),
          Styled.text(label)
              .fontSize(11)
              .paddingSymmetric(horizontal: 4)
              .backgroundColor(Colors.white)
              .positioned(top: -7, left: 9)
        ].toStack(clipBehavior: Clip.none),
      ),
    );
  }
}

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    super.key,
    required this.date,
    required this.time,
  });

  final Rx<DateTime?> date;
  final Rx<TimeOfDay?> time;

  @override
  Widget build(BuildContext context) {
    return [
      [
        Obx(
          () => Styled.text(date.value != null
                  ? "${date.value!.day > 9 ? date.value!.day : '0${date.value!.day}'}/${date.value!.month > 9 ? date.value!.month : '0${date.value!.month}'}/${date.value!.year}"
                  : "--/--/--")
              .fontSize(14)
              .paddingSymmetric(vertical: 5, horizontal: 10)
              .ripple()
              .gestures(
            onTap: () async {
              final date = (await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                  onDatePickerModeChange: (value) {
                    print(value);
                  }));
              if (date != null) {
                this.date.value = date;
              }
            },
          ).clipRRect(all: 10),
        ),
        Styled.text("/")
            .fontSize(16)
            .fontWeight(FontWeight.bold)
            .paddingSymmetric(horizontal: 30),
        Obx(
          () => Styled.text(time.value != null
                  ? time.value!.format(context)
                  : "-- all - day --")
              .fontSize(14)
              .paddingSymmetric(vertical: 5, horizontal: 10)
              .ripple()
              .gestures(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              this.time.value = time;
            },
          ).clipRRect(all: 10),
        ),
      ]
          .toRow()
          .paddingSymmetric(vertical: 5, horizontal: 20)
          .height(50)
          .width(double.infinity)
          .decorated(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(10),
          ),
      Styled.text("Date  / Time")
          .fontSize(11)
          .paddingSymmetric(horizontal: 4)
          .backgroundColor(Colors.white)
          .positioned(top: -7, left: 9)
    ].toStack(clipBehavior: Clip.none);
  }
}

class RxImagePicker extends StatelessWidget {
  const RxImagePicker({
    super.key,
    required this.bytes,
    required this.label,
    this.isRequired = false,
  });

  final Rx<Uint8List?> bytes;
  final String label;
  final bool isRequired;

  Future<void> selectPhoto(BuildContext context) async {
    final source = await showCupertinoDialog<ImageSource>(
      context: context,
      barrierDismissible: true,
      builder: (c) => CupertinoAlertDialog(
        title: Styled.text("Image Source"),
        content: ImageSource.values
            .map(
              (s) => Styled.text(s.name.capitalizeFirst ?? "")
                  .fontSize(16)
                  .center()
                  .padding(vertical: 10)
                  .ripple()
                  .gestures(
                    onTap: () {
                      Navigator.of(c).pop(s);
                    },
                  )
                  .clipRRect(all: 10)
                  .width(double.infinity),
            )
            .toList()
            .toColumn(
              separator: const SizedBox(
                height: 10,
              ),
            )
            .padding(top: 20),
      ),
    );
    if (source == null) return;
    final file = await ImagePicker().pickImage(source: source);
    if (file != null) bytes.value = await file.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return [
      [
        Obx(
          () => (bytes.value != null
                  ? Image.memory(bytes.value!, height: 300,)
                      .gestures(onTap: () => selectPhoto(context))
                  : Styled.widget(
                      child: [
                        Styled.text("Select image").fontSize(14),
                        Styled.icon(Icons.image).iconSize(20),
                      ].toRow(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        separator: const SizedBox(
                          width: 10,
                        ),
                      ),
                    )
                      .paddingSymmetric(horizontal: 10)
                      .ripple()
                      .gestures(onTap: () => selectPhoto(context))
                      .clipRRect(all: 10))
              .paddingSymmetric(vertical: 5, horizontal: 10)
              .constrained(minHeight: 50)
              .width(double.infinity)
              .decorated(
                border: Border.all(
                  color: isRequired
                      ? (bytes.value != null
                          ? Colors.black54
                          : Colors.red.shade500)
                      : Colors.black54,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
        ),
        Obx(
          () => Visibility(
            visible: bytes.value != null,
            child: Button(
              text: "Remove photo",
              icon: CupertinoIcons.trash,
              color: Colors.red,
              onTap: () => bytes.value = null,
            ),
          ),
        )
      ].toColumn(
        separator: const SizedBox(
          height: 5,
        ),
      ),
      Styled.text(label)
          .fontSize(11)
          .paddingSymmetric(horizontal: 4)
          .backgroundColor(Colors.white)
          .positioned(top: -7, left: 9)
    ].toStack(clipBehavior: Clip.none);
  }
}
