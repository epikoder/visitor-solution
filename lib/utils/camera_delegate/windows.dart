// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:visitor_solution/services/navigator.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/utils/camera_delegate/platform_delegate.dart';
import 'package:visitor_solution/views/components/button.component.dart';

class WindowsCameraController extends CameraController
    implements PlatformCameraController {
  WindowsCameraController(super.description, super.resolutionPreset);

  @override
  Future<void> pause() async {
    return await super.pausePreview();
  }

  @override
  Future<void> resume() async {
    return await super.resumePreview();
  }
}

class WindowsCameraDelegate extends ImagePickerCameraDelegate {
  WindowsCameraDelegate() {
    enumerateCameras();
  }

  List<CameraDescription>? cameras;
  CameraDescription? defaultCamera;

  @override
  Future<XFile?> takePhoto(
      {ImagePickerCameraDelegateOptions options =
          const ImagePickerCameraDelegateOptions()}) async {
    if (cameras == null) await enumerateCameras();
    if (cameras!.isEmpty) {
      Get.showSnackbar(const GetSnackBar(
        title: "Camera Not found",
        message: "No suitable camera found",
      ));
      return null;
    }

    final camera = await selectCamera();
    if (camera == null) return null;

    WindowsCameraController cameraController = WindowsCameraController(
      camera,
      ResolutionPreset.max,
    );

    await cameraController.initialize();
    final file = await showCupertinoDialog<XFile?>(
      context: NavigatorService.navigatorKey.currentContext!,
      builder: (context) => Visibility(
        visible: context.mounted,
        child: [
          CameraPreview(
            cameraController,
            child: CameraActions(
              controller: cameraController,
            ),
          ).constrained(maxHeight: 500, maxWidth: 800),
          Button(
            text: "Close",
            icon: CupertinoIcons.clear,
            color: Colors.red,
            onTap: () async {
              await cameraController.dispose();
              Navigator.of(context).pop();
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
    Future.delayed(const Duration(seconds: 1), () async {
      await cameraController.dispose();
    });
    return file;
  }

  @override
  Future<XFile?> takeVideo(
      {ImagePickerCameraDelegateOptions options =
          const ImagePickerCameraDelegateOptions()}) {
    return Future.value(null);
  }

  Future<void> enumerateCameras() async {
    cameras = await availableCameras();
  }

  Future<CameraDescription?> selectCamera() async {
    return await showCupertinoDialog<CameraDescription?>(
      barrierDismissible: true,
      context: NavigatorService.navigatorKey.currentContext!,
      builder: (context) => Visibility(
        visible: context.mounted,
        child: CupertinoAlertDialog(
          title: Styled.text("Select Camera device"),
          content: cameras!
              .map(
                (cam) => Styled.text(
                        "${cam.name.split('<').first.trim()} - ${cam.lensDirection.name.capitalizeFirst}")
                    .fontSize(16)
                    .padding(vertical: 5, horizontal: 10)
                    .width(double.infinity)
                    .ripple()
                    .gestures(onTap: () {
                      Navigator.of(context).pop(cam);
                    })
                    .clipRRect(all: 10)
                    .padding(horizontal: 5),
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
  }
}
