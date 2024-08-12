import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/views/components/fragment.component.dart';
import 'package:visitor_solution/views/components/fragment.appbar.component.dart';
import 'package:visitor_solution/views/components/button.component.dart';
import 'package:visitor_solution/views/components/modal.component.dart';
import 'package:visitor_solution/views/fragments/components/visitor.form.dart';

class VisitorsFragment extends StatelessWidget {
  const VisitorsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final modalController = ModalController();

    return Fragment(
      appBar: FragmentAppBar(
        title: "Visitors",
        actions: [
          Button(
            text: "New",
            icon: CupertinoIcons.square_pencil,
            onTap: modalController.openModal,
          ),
        ],
      ),
      body: <Widget>[].toColumn(),
      modal: Modal(
        controller: modalController,
        header: ModalHeader(
          title: "Add Visitor",
          actions: [
            StyledIconButton(
              icon: CupertinoIcons.clear,
              color: Colors.white,
              bgColor: Colors.red.shade500,
              onTap: modalController.closeModal,
            )
          ],
        ),
        body: const VisitorForm(),
      ),
    );
  }
}
