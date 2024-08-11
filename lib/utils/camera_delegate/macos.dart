// ignore_for_file: use_build_context_synchronously

import 'package:camera_macos/camera_macos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:visitor_solution/services/navigator.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/utils/camera_delegate/platform_delegate.dart';
import 'package:visitor_solution/views/components/button.component.dart';

class MacOsCameraController extends CameraMacOSController
    implements PlatformCameraController {
  MacOsCameraController(super.args);

  @override
  Future<void> dispose() {
    return super.destroy();
  }

  @override
  Future<void> pause() async {}

  @override
  Future<void> resume() async {}
}

class MacosCameraDelegate extends ImagePickerCameraDelegate {
  @override
  Future<XFile?> takePhoto(
      {Object options = const ImagePickerCameraDelegateOptions()}) async {
    List<CameraMacOSDevice> cameras = await CameraMacOS.instance
        .listDevices(deviceType: CameraMacOSDeviceType.video);

    final camera = await showCupertinoDialog<CameraMacOSDevice?>(
      barrierDismissible: true,
      context: NavigatorService.navigatorKey.currentContext!,
      builder: (context) => Visibility(
        visible: context.mounted,
        child: CupertinoAlertDialog(
          title: Styled.text("Select Camera device"),
          content: cameras
              .map(
                (cam) => Styled.text(cam.localizedName ?? cam.deviceId)
                    .fontSize(16)
                    .padding(vertical: 5, horizontal: 10)
                    .width(double.infinity)
                    .ripple()
                    .gestures(onTap: () {
                      Navigator.of(context).pop(cam);
                    })
                    .clipRRect(all: 10)
                    .padding(horizontal: 10),
              )
              .toList()
              .toColumn(
                separator: const SizedBox(
                  height: 10,
                ),
              )
              .padding(top: 20),
        ),
      ),
    );

    if (camera == null) return null;

    late MacOsCameraController cameraController;
    final file = await showCupertinoDialog<XFile?>(
      context: NavigatorService.navigatorKey.currentContext!,
      builder: (context) => Visibility(
        visible: context.mounted,
        child: [
          CameraMacOSView(
            deviceId: camera.deviceId,
            cameraMode: CameraMacOSMode.video,
            onCameraInizialized: (CameraMacOSController controller) {
              cameraController = controller as MacOsCameraController;
            },
          ).constrained(maxHeight: 500),
          Button(
            text: "Close",
            icon: CupertinoIcons.clear,
            color: Colors.red,
            onTap: () async {
              await cameraController.destroy();
              Navigator.of(context).pop(null);
            },
          ),
        ]
            .toColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              separator: const SizedBox(
                height: 10,
              ),
            )
            .center(),
      ),
    );

    await cameraController.dispose();
    return file;
  }

  @override
  Future<XFile?> takeVideo(
      {ImagePickerCameraDelegateOptions options =
          const ImagePickerCameraDelegateOptions()}) {
    return Future.value(null);
  }
}
