import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/models/visitor.model.dart';
import 'package:visitor_solution/utils/camera_delegate/platform_delegate.dart';
import 'package:visitor_solution/utils/camera_delegate/windows.dart';
import 'package:visitor_solution/utils/client.dart';
import 'package:visitor_solution/utils/logger.dart';
import 'package:visitor_solution/views/components/fragment.component.dart';
import 'package:visitor_solution/views/components/fragment.appbar.component.dart';
import 'package:visitor_solution/views/components/input.component.dart';
import 'package:visitor_solution/views/components/modal.component.dart';
import 'package:visitor_solution/views/fragments/components/visitor.information.modal.dart';
import 'package:visitor_solution/views/shared/app.shared.dart';
// import 'package:flutter_zxing/flutter_zxing.dart';

class _ScanFragmentController extends GetxController {
  Rx<PlatformCameraController?> cameraController = Rx(null);
  final vidController = TextEditingController();

  final modalController = ModalController();

  final _scannerStarted = false.obs;
  final Rx<Visitor?> visitor = Rx(null);

  bool get isScannerStarted => _scannerStarted.value;

  @override
  void dispose() {
    cameraController.value?.dispose();
    vidController.dispose();
    super.dispose();
  }

  Future<void> startScanner() async {
    cameraController.value = await getCameraController();
    if (cameraController.value is WindowsCameraController) {
      await (cameraController.value as WindowsCameraController).initialize();
    }
    _scannerStarted.value = true;

    // Future.doWhile(() async {
    //   return await Future.delayed(const Duration(milliseconds: 300), () async {
    //     if (cameraController.value == null) return false;
    //     try {
    //       if (cameraController.value is MacOsCameraController) {
    //         final pic = await (cameraController.value as MacOsCameraController)
    //             .takePicture();
    //         if (pic != null) {
    //           // final results = zx.readBarcode(
    //           //     pic.bytes!,
    //           //     DecodeParams(
    //           //       format: Format.qrCode,
    //           //     ));
    //           // final id = results.text;
    //           // if (id != null) {
    //           //   await stopScanner();
    //           //   findVisitor(id);
    //           //   return false;
    //           // }
    //         }
    //       } else {
    //         final pic =
    //             await (cameraController.value as WindowsCameraController)
    //                 .takePicture();
    //         // final results =
    //         //     zx.readBarcode(await pic.readAsBytes(), DecodeParams());
    //         // logger(results.text);
    //         // final id = results.text;
    //         // if (id != null) {
    //         //   await stopScanner();
    //         //   findVisitor(id);
    //         //   return false;
    //         // }
    //       }
    //     } catch (e) {
    //       logger(e, label: "LISTEN FOR QR ${e.runtimeType}");
    //       if (e is Map && e["code"] == "PHOTO_OUTPUT_ERROR") {
    //         return true;
    //       }
    //       return false;
    //     }
    //     return true;
    //   });
    // });
  }

  Future<void> stopScanner() async {
    if (cameraController.value != null) await cameraController.value?.dispose();
    _scannerStarted.value = false;
    cameraController.value = null;
  }

  Future<void> findVisitor(String id) async {
    final appController = Get.find<AppViewController>();
    appController.setIsLoading();
    logger(id);
    try {
      final v = await Client.instance
          .from("visitors")
          .select()
          .eq("vid", id)
          .single();
      visitor.value = Visitor.fromJson(v);
    } catch (e, s) {
      logError(e, stackTrace: s);
    }
    appController.setIsNotLoading();
    modalController.openModal();
  }
}

class ScanFragment extends StatefulWidget {
  const ScanFragment({super.key});

  @override
  ScanFragmentState createState() => ScanFragmentState();
}

class ScanFragmentState extends State<ScanFragment> {
  final controller = _ScanFragmentController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Fragment(
      appBar: const FragmentAppBar(title: "Scan"),
      body: <Widget>[
        // Obx(
        //   () => controller.cameraController.value != null &&
        //           controller.isScannerStarted
        //       ? PlatformScannerView(
        //           controller: controller.cameraController,
        //         )
        //       : const SizedBox(),
        // ),
        // [
        //   Obx(
        //     () => Visibility(
        //       visible: !controller.isScannerStarted,
        //       child: Button(
        //         text: "Start",
        //         icon: CupertinoIcons.camera,
        //         onTap: controller.startScanner,
        //         horizontalPadding: 40,
        //         verticalPadding: 20,
        //       ),
        //     ),
        //   ),
        //   Obx(
        //     () => Visibility(
        //       visible: controller.isScannerStarted,
        //       child: Button(
        //         text: "Stop",
        //         icon: CupertinoIcons.camera,
        //         onTap: controller.stopScanner,
        //         color: Colors.red,
        //         horizontalPadding: 40,
        //         verticalPadding: 20,
        //       ),
        //     ),
        //   ),
        // ].toColumn(mainAxisSize: MainAxisSize.min),
        TextInput(
          controller: controller.vidController,
          label: "Visitor - ID",
          onEditingComplete: () =>
              controller.findVisitor(controller.vidController.text),
        ).constrained(maxWidth: 500).padding(vertical: 20)
      ]
          .toColumn(
            separator: const SizedBox(
              height: 10,
            ),
          )
          .padding(vertical: 20),
      modal: Obx(() => controller.visitor.value != null
          ? visitorInformationModal(
              context, controller.modalController, controller.visitor)
          : const SizedBox()),
    );
  }
}
