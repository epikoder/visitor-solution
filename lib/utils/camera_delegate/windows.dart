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
    implements PlatformCameraController<XFile?> {
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
  @override
  Future<XFile?> takePhoto(
      {ImagePickerCameraDelegateOptions options =
          const ImagePickerCameraDelegateOptions()}) async {
    final cameras = await enumerateCameras();
    if (cameras.isEmpty) {
      Get.showSnackbar(const GetSnackBar(
        title: "Camera Not found",
        message: "No suitable camera found",
      ));
      return null;
    }

    final camera =
        cameras.length > 1 ? await selectCamera(cameras) : cameras.first;
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
          ).constrained(maxHeight: 500, maxWidth: 500),
          Button(
            text: "Close",
            icon: CupertinoIcons.clear,
            color: Colors.red,
            onTap: () {
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

  static Future<List<CameraDescription>> enumerateCameras() async {
    return await availableCameras();
  }

  static Future<CameraDescription?> selectCamera(
      List<CameraDescription> cameras) async {
    return await showCupertinoDialog<CameraDescription?>(
      barrierDismissible: true,
      context: NavigatorService.navigatorKey.currentContext!,
      builder: (context) => Visibility(
        visible: context.mounted,
        child: CupertinoAlertDialog(
          title: Styled.text("Select Camera device"),
          content: cameras
              .map(
                (cam) => Styled.text(cam.name.split('<').first.trim())
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

  static Future<PlatformCameraController<XFile?>?> controller() async {
    final cameras = await enumerateCameras();
    final camera =
        cameras.length > 1 ? await selectCamera(cameras) : cameras.first;
    if (camera == null) return null;
    final controller = WindowsCameraController(camera, ResolutionPreset.low);
    return controller;
  }
}

// class WindowsCameraDevice extends CameraDescription implements PlatformCameraDevice {
//   @override
//   String deviceId() {
//     return super.name;
//   }

//   @override
//   String deviceName() {
//     return super.name;
//   }
  
// }