import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

class ModalController extends GetxController {
  final _isOpen = false.obs;

  bool get isOpen => _isOpen.value;

  void openModal() {
    _isOpen.value = true;
  }

  void closeModal() {
    _isOpen.value = false;
  }
}

class Modal extends StatelessWidget {
  const Modal({
    super.key,
    required this.controller,
    required this.header,
    required this.body,
  });

  final ModalController controller;
  final Widget body;
  final ModalHeader? header;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.isOpen,
        child: [if (header != null) header!, body]
            .toColumn()
            .width(double.infinity)
            .backgroundColor(Colors.white)
            .height(MediaQuery.of(context).size.height)
            .constrained(
              maxWidth: MediaQuery.of(context).size.width > 1024 ? 500 : 400,
              minWidth: 400,
            )
            .elevation(10),
      ),
    )
        .positioned(top: 0, right: 0, animate: true)
        .animate(const Duration(milliseconds: 300), Curves.easeIn);
  }
}

class ModalHeader extends StatelessWidget {
  const ModalHeader({
    super.key,
    required this.title,
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      Styled.text(title).center().expanded(flex: 1),
      if (actions != null) actions!.toRow(),
    ]
        .toRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          separator: const SizedBox(
            width: 10,
          ),
        )
        .paddingSymmetric(horizontal: 10)
        .border(bottom: 1, color: Colors.grey.shade400)
        .height(50)
        .width(double.infinity);
  }
}
