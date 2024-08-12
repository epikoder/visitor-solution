import 'package:camera_macos/camera_macos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:visitor_solution/services/navigator.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/utils/camera_delegate/platform_delegate.dart';
import 'package:visitor_solution/views/components/button.component.dart';

class MacOsCameraController extends PlatformCameraController<CameraMacOSFile?> {
  MacOsCameraController(this.inner);
  final CameraMacOSController inner;

  @override
  Future<void> dispose() {
    return inner.destroy();
  }

  @override
  Future<void> pause() async {}

  @override
  Future<void> resume() async {}

  @override
  bool isResumable() => false;

  @override
  Future<CameraMacOSFile?> takePicture() {
    return inner.takePicture();
  }
}

class MacosCameraDelegate extends ImagePickerCameraDelegate {
  @override
  Future<XFile?> takePhoto(
      {Object options = const ImagePickerCameraDelegateOptions()}) async {
    List<CameraMacOSDevice> cameras = await enumerateCameras();

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

    final file = await showCupertinoDialog<CameraMacOSFile?>(
      context: NavigatorService.navigatorKey.currentContext!,
      builder: (c) => MacosCameraPreview(
        camera: camera,
      ),
    );
    if (file == null) return null;

    return XFile.fromData(file.bytes!);
  }

  @override
  Future<XFile?> takeVideo(
      {ImagePickerCameraDelegateOptions options =
          const ImagePickerCameraDelegateOptions()}) {
    return Future.value(null);
  }

  static Future<List<CameraMacOSDevice>> enumerateCameras() async {
    return await CameraMacOS.instance
        .listDevices(deviceType: CameraMacOSDeviceType.video);
  }

  static Future<CameraMacOSDevice?> selectCamera(
      List<CameraMacOSDevice> cameras) async {
    return await showCupertinoDialog<CameraMacOSDevice?>(
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
  }

  static Future<PlatformCameraController<CameraMacOSFile?>?>
      controller() async {
    final cameras = await enumerateCameras();
    final camera =
        cameras.length > 1 ? await selectCamera(cameras) : cameras.first;
    if (camera == null) return null;
    return MacOsCameraController(
      CameraMacOSController(
        CameraMacOSArguments(
          size: const Size(400, 400),
        ),
      ),
    );
  }
}

class MacosCameraPreview extends StatefulWidget {
  const MacosCameraPreview({
    super.key,
    required this.camera,
  });

  final CameraMacOSDevice camera;

  @override
  MacosCameraPreviewState createState() => MacosCameraPreviewState();
}

class MacosCameraPreviewState extends State<MacosCameraPreview> {
  MacOsCameraController? controller;
  bool isInitialized = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return [
      [
        CameraMacOSView(
          deviceId: widget.camera.deviceId,
          cameraMode: CameraMacOSMode.video,
          onCameraInizialized: (CameraMacOSController controller) {
            this.controller = MacOsCameraController(controller);
            setState(() {
              isInitialized = true;
            });
          },
        ),
        if (controller != null)
          CameraActions<CameraMacOSFile?>(controller: controller!)
              .alignment(Alignment.bottomCenter)
              .alignment(Alignment.bottomCenter),
      ].toStack().constrained(maxHeight: 400, maxWidth: 500),
      if (isInitialized)
        Button(
          text: "Close",
          icon: CupertinoIcons.clear,
          color: Colors.red,
          onTap: () {
            Navigator.of(context).pop(null);
          },
        ),
    ]
        .toColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          separator: const SizedBox(
            height: 10,
          ),
        )
        .scrollable()
        .center();
  }
}
