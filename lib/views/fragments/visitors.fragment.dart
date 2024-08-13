import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/models/visitor.model.dart';
import 'package:visitor_solution/utils/client.dart';
import 'package:visitor_solution/utils/logger.dart';
import 'package:visitor_solution/views/components/fragment.component.dart';
import 'package:visitor_solution/views/components/fragment.appbar.component.dart';
import 'package:visitor_solution/views/components/button.component.dart';
import 'package:visitor_solution/views/components/input.component.dart';
import 'package:visitor_solution/views/components/modal.component.dart';
import 'package:visitor_solution/views/fragments/components/visitor.card.dart';
import 'package:visitor_solution/views/fragments/components/visitor.form.dart';
import 'package:visitor_solution/views/fragments/components/visitor.information.modal.dart';
import 'package:visitor_solution/views/fragments/shared/visitors.shared.dart';

class VisitorsFragment extends StatelessWidget {
  const VisitorsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VisitorsFragmentController());

    return Fragment(
      appBar: FragmentAppBar(
        title: "Visitors",
        actions: [
          Button(
            text: "Reload",
            color: Colors.green.shade500,
            icon: CupertinoIcons.refresh_circled,
            onTap: controller.load,
          ),
          Button(
            text: "New",
            icon: CupertinoIcons.square_pencil,
            onTap: controller.modalController.openModal,
          ),
        ],
      ),
      body: <Widget>[
        TextInput(
          controller: controller.searchController,
          label: "Search Viistor-ID",
          onEditingComplete: controller.search,
        ).constrained(maxWidth: 500).padding(vertical: 20),
        Obx(
          () => Visibility(
            visible: controller.loading.value,
            child: const CupertinoActivityIndicator(),
          ),
        ),
        Obx(
          () => controller.visitors
              .map((visitor) => VisitorCard(
                    visitor: visitor,
                    onTap: () => controller.selectVisitor(visitor),
                  ))
              .toList()
              .toColumn()
              .padding(horizontal: 50)
              .scrollable()
              .expanded(flex: 1),
        )
      ].toColumn(),
      modal: Obx(() => controller.visitor.value != null
          ? visitorInformationModal(
              context, controller.modalController, controller.visitor,
              onClose: controller.resetVisitor)
          : Modal(
              controller: controller.modalController,
              header: ModalHeader(
                title: "Add Visitor",
                actions: [
                  StyledIconButton(
                    icon: CupertinoIcons.clear,
                    color: Colors.white,
                    bgColor: Colors.red.shade500,
                    onTap: controller.modalController.closeModal,
                  )
                ],
              ),
              body: VisitorForm(onSubmit: (vid) async {
                controller.modalController.closeModal();
                await controller.load();
                controller.visitor.value =
                    controller.visitors.firstWhereOrNull((v) => v.vid == vid);
              }),
            )),
    );
  }
}
