import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_macos/camera_macos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/services/navigator.dart';
import 'package:visitor_solution/views/components/button.component.dart';
import 'package:get/get.dart';

class CameraDelegate extends ImagePickerCameraDelegate {
  @override
  Future<XFile?> takePhoto(
      {ImagePickerCameraDelegateOptions options =
          const ImagePickerCameraDelegateOptions()}) async {
    return _takePhoto(options.preferredCameraDevice);
  }

  @override
  Future<XFile?> takeVideo(
      {ImagePickerCameraDelegateOptions options =
          const ImagePickerCameraDelegateOptions()}) async {
    return _takeVideo(options.preferredCameraDevice);
  }

  Future<XFile?> _takePhoto(CameraDevice preferredCameraDevice) async {
    if (Platform.isMacOS) {
      await _takePhotoMacOs();
    } else if (Platform.isWindows) {
      await _takePhotoWindows();
    }
    return null;
  }

  _takePhotoMacOs() async {
    late CameraMacOSController cameraMacOSController;
    String? deviceId;
    String? audioDeviceId;

    List<CameraMacOSDevice> videoDevices = await CameraMacOS.instance
        .listDevices(deviceType: CameraMacOSDeviceType.video);

    deviceId = videoDevices.first.deviceId;
    final ca = await showCupertinoDialog(
      context: NavigatorService.navigatorKey.currentContext!,
      builder: (context) => [
        CameraMacOSView(
          deviceId: deviceId,
          cameraMode: CameraMacOSMode.video,
          onCameraInizialized: (CameraMacOSController controller) {
            cameraMacOSController = controller;
          },
        ).constrained(maxHeight: 500),
        Button(
          text: "Close",
          icon: CupertinoIcons.clear,
          color: Colors.red,
          onTap: () async {
            await cameraMacOSController.destroy();
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
    );
  }

  _takePhotoWindows() async {
    if (cameras == null) await enumerateCameras();
    if (cameras!.isEmpty) {
      Get.showSnackbar(const GetSnackBar(
        title: "Camera Not found",
        message: "No suitable camera found",
      ));
      return;
    }
    CameraController cameraController = CameraController(
      cameras![0],
      ResolutionPreset.max,
    );
    String? deviceId;
    String? audioDeviceId;

    List<CameraMacOSDevice> videoDevices = await CameraMacOS.instance
        .listDevices(deviceType: CameraMacOSDeviceType.video);

    deviceId = videoDevices.first.deviceId;
    final ca = await showCupertinoDialog(
      context: NavigatorService.navigatorKey.currentContext!,
      builder: (context) => [
        cameraController.buildPreview().constrained(maxHeight: 500),
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
    );
  }

  Future<XFile?> _takeVideo(CameraDevice preferredCameraDevice) async {
    return null;
  }

  List<CameraDescription>? cameras;

  Future<void> enumerateCameras() async {
    cameras = await availableCameras();
  }
}

void setUpCameraDelegate() {
  final ImagePickerPlatform instance = ImagePickerPlatform.instance;
  if (instance is CameraDelegatingImagePickerPlatform) {
    final cameraDelegate = CameraDelegate();
    cameraDelegate.enumerateCameras();
    instance.cameraDelegate = cameraDelegate;
  }
}
