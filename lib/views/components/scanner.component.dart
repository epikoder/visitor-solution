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

class PlatformScannerView extends StatelessWidget {
  const PlatformScannerView({
    super.key,
    required this.controller,
  });

  final PlatformCameraController controller;

  @override
  Widget build(BuildContext context) {
    return (Platform.isWindows
        ? FittedBox(
            fit: BoxFit.fill,
            child: ClipRect(
              child: Align(
                alignment: Alignment.center,
                widthFactor: .74,
                child: CameraPreview(
                  controller as WindowsCameraController,
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
        : FutureBuilder(
            future: () async {
              List<CameraMacOSDevice> cameras =
                  await MacosCameraDelegate.enumerateCameras();

              if (cameras.isEmpty) {
                Get.showSnackbar(const GetSnackBar(
                  title: "Camera Not found",
                  message: "No suitable camera found",
                ));
                return null;
              }

              final camera = cameras.length > 1
                  ? await MacosCameraDelegate.selectCamera(cameras)
                  : cameras.first;
              if (camera == null) {
                return Styled.text("No Camera Device found");
              }

              return CameraMacOSView(
                deviceId: camera.deviceId,
                cameraMode: CameraMacOSMode.video,
                onCameraInizialized: (CameraMacOSController controller) {
                  controller = controller as MacOsCameraController;
                },
              );
            }(),
            builder: (c, snapshot) => Visibility(
                visible: snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null,
                child: snapshot.data!),
          ));
  }
}
