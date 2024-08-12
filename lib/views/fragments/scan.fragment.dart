import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/utils/camera_delegate/macos.dart';
import 'package:visitor_solution/utils/camera_delegate/platform_delegate.dart';
import 'package:visitor_solution/utils/camera_delegate/windows.dart';
import 'package:visitor_solution/utils/logger.dart';
import 'package:visitor_solution/utils/qr.dart';
import 'package:visitor_solution/views/components/fragment.component.dart';
import 'package:visitor_solution/views/components/fragment.appbar.component.dart';
import 'package:visitor_solution/views/components/button.component.dart';
import 'package:visitor_solution/views/components/modal.component.dart';
import 'package:visitor_solution/views/components/scanner.component.dart';
import 'package:visitor_solution/views/shared/app.shared.dart';

class _Controller extends GetxController {
  Rx<PlatformCameraController?> cameraController = Rx(null);

  final modalController = ModalController();

  final _scannerStarted = false.obs;

  bool get isScannerStarted => _scannerStarted.value;

  @override
  void dispose() {
    cameraController.value?.dispose();
    super.dispose();
  }

  Future<void> startScanner() async {
    cameraController.value = await getCameraController();
    if (cameraController.value is WindowsCameraController) {
      await (cameraController.value as CameraController).initialize();
    }
    _scannerStarted.value = true;

    Future.doWhile(() async {
      return await Future.delayed(const Duration(milliseconds: 300), () async {
        if (cameraController.value == null) return false;
        try {
          if (cameraController.value is MacOsCameraController) {
            final pic = await (cameraController.value as MacOsCameraController)
                .takePicture();
            final results = await QR.sdk.decodeFile(pic!.url!);
          } else {
            final pic =
                await (cameraController.value as WindowsCameraController)
                    .takePicture();
            final results = await QR.sdk.decodeFile(pic.path);
            final id = results.firstOrNull?.text;
            if (id != null) {
              await stopScanner();
              findVisitor(id);
              return false;
            }
          }
        } catch (e) {
          logger(e);
          return false;
        }
        return true;
      });
    });
  }

  Future<void> stopScanner() async {
    if (cameraController.value != null) await cameraController.value?.dispose();
    _scannerStarted.value = false;
    cameraController.value = null;
  }

  Future<void> findVisitor(String id) async {
    final appController = Get.find<AppViewController>();
    appController.setIsLoading();
    await Future.delayed(
        const Duration(seconds: 3), appController.setIsNotLoading);
    modalController.openModal();
  }
}

class ScanFragment extends StatefulWidget {
  const ScanFragment({super.key});

  @override
  ScanFragmentState createState() => ScanFragmentState();
}

class ScanFragmentState extends State<ScanFragment> {
  final controller = _Controller();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Fragment(
      appBar: const FragmentAppBar(title: "Scan"),
      body: [
        Obx(
          () => controller.cameraController.value != null &&
                  controller.isScannerStarted
              ? PlatformScannerView(
                  controller: controller.cameraController.value!)
              : const SizedBox(),
        ),
        [
          Obx(
            () => Visibility(
              visible: !controller.isScannerStarted,
              child: Button(
                text: "Start",
                icon: CupertinoIcons.camera,
                onTap: controller.startScanner,
                horizontalPadding: 40,
                verticalPadding: 20,
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: controller.isScannerStarted,
              child: Button(
                text: "Stop",
                icon: CupertinoIcons.camera,
                onTap: controller.stopScanner,
                color: Colors.red,
                horizontalPadding: 40,
                verticalPadding: 20,
              ),
            ),
          ),
        ].toColumn(mainAxisSize: MainAxisSize.min),
      ]
          .toColumn(
            mainAxisAlignment: MainAxisAlignment.center,
            separator: const SizedBox(
              height: 10,
            ),
          )
          .padding(vertical: 20),
      modal: Modal(
        controller: controller.modalController,
        header: ModalHeader(
          title: "Visitor",
          actions: [
            StyledIconButton(
              icon: CupertinoIcons.clear,
              bgColor: Colors.red,
              onTap: controller.modalController.closeModal,
            )
          ],
        ),
        body: <Widget>[Styled.text("Visitor information will be here")]
            .toColumn()
            .scrollable(),
      ),
    );
  }
}
