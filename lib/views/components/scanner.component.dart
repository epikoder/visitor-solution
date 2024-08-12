import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_macos/camera_macos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/utils/camera_delegate/macos.dart';
import 'package:visitor_solution/utils/camera_delegate/platform_delegate.dart';
import 'package:visitor_solution/utils/camera_delegate/windows.dart';

class PlatformScannerView extends StatefulWidget {
  const PlatformScannerView({
    super.key,
    required this.controller,
  });

  final Rx<PlatformCameraController?> controller;

  @override
  PlatformScannerViewState createState() => PlatformScannerViewState();
}

class PlatformScannerViewState extends State<PlatformScannerView> {
  CameraMacOSDevice? cameraDevice;
  bool isInitialized = false;

  @override
  void initState() {
    setupCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isWindows) {
      assert(widget.controller.value != null,
          "WindowsCameraController cannot be null");
    }

    return Platform.isWindows
        ? FittedBox(
            fit: BoxFit.fill,
            child: ClipRect(
              child: Align(
                alignment: Alignment.center,
                widthFactor: .74,
                child: CameraPreview(
                  (widget.controller).value as WindowsCameraController,
                  child: QRScannerOverlay(
                    borderColor: Colors.white,
                    overlayColor: Colors.transparent,
                    scanAreaHeight: 400,
                    scanAreaWidth: 430,
                  ).clipRRect(all: 50),
                )
                    .height(double.infinity)
                    .width(double.infinity)
                    .constrained(maxHeight: 480, maxWidth: 640),
              ),
            ).clipRRect(all: 20),
          )
        : isInitialized
            ? (cameraDevice != null
                ? [
                    FittedBox(
                      fit: BoxFit.fill,
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.center,
                          widthFactor: .9,
                          heightFactor: .8,
                          child: CameraMacOSView(
                            deviceId: cameraDevice!.deviceId,
                            cameraMode: CameraMacOSMode.video,
                            onCameraInizialized:
                                (CameraMacOSController controller) {
                              widget.controller.value =
                                  MacOsCameraController(controller);
                            },
                          ),
                        ),
                      ),
                    ),
                    QRScannerOverlay(
                      borderColor: Colors.black,
                      overlayColor: Colors.white,
                      scanAreaWidth: 450,
                      scanAreaHeight: 250,
                    ),
                  ].toStack().constrained(maxHeight: 400, maxWidth: 500)
                : Styled.text("No Camera Device found"))
            : const SizedBox();
  }

  Future<void> setupCamera() async {
    if (Platform.isMacOS) {
      List<CameraMacOSDevice> cameras =
          await MacosCameraDelegate.enumerateCameras();

      cameraDevice = cameras.length > 1
          ? await MacosCameraDelegate.selectCamera(cameras)
          : cameras.firstOrNull;
    }

    setState(() {
      isInitialized = true;
    });
  }
}
