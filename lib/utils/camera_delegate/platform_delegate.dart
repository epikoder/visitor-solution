import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:visitor_solution/utils/camera_delegate/macos.dart';
import 'package:visitor_solution/utils/camera_delegate/windows.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/views/components/button.component.dart';

abstract class PlatformCameraController<T> {
  Future<T?> takePicture();
  Future<void> dispose();
  Future<void> pause();
  Future<void> resume();
  bool isResumable();
}

abstract class PlatformCameraDevice<T> {
  String deviceName();
  String deviceId();
}

void setUpCameraDelegate() {
  final ImagePickerPlatform instance = ImagePickerPlatform.instance;
  if (instance is CameraDelegatingImagePickerPlatform) {
    late ImagePickerCameraDelegate cameraDelegate;
    if (Platform.isMacOS) {
      cameraDelegate = MacosCameraDelegate();
    } else if (Platform.isWindows) {
      cameraDelegate = WindowsCameraDelegate();
    } else {
      return;
    }
    instance.cameraDelegate = cameraDelegate;
  }
}

class CameraActions<T> extends StatefulWidget {
  const CameraActions({
    super.key,
    required this.controller,
  });

  final PlatformCameraController<T> controller;

  @override
  CameraActionsState<T> createState() => CameraActionsState<T>();
}

class CameraActionsState<T> extends State<CameraActions<T>> {
  T? file;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      StyledIconButton(
        icon: CupertinoIcons.camera,
        iconSize: 18,
        onTap: () async {
          final newFile = await widget.controller.takePicture();
          setState(() {
            file = newFile;
          });
          await widget.controller.pause();
          if (!widget.controller.isResumable()) {
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop(file);
          }
        },
      ),
      if (file != null && widget.controller.isResumable())
        [
          StyledIconButton(
            icon: CupertinoIcons.check_mark,
            iconSize: 18,
            onTap: () {
              Navigator.of(context).pop(file);
            },
          ),
          StyledIconButton(
            icon: CupertinoIcons.clear,
            bgColor: Colors.red,
            iconSize: 18,
            onTap: () async {
              setState(() {
                file = null;
              });
              await widget.controller.resume();
            },
          ),
        ].toRow(
          separator: const SizedBox(
            width: 10,
          ),
          mainAxisSize: MainAxisSize.min,
        )
    ]
        .toRow(
          separator: const SizedBox(
            width: 10,
          ),
          mainAxisSize: MainAxisSize.min,
        )
        .padding(vertical: 5, horizontal: 40)
        .backgroundColor(Colors.white.withOpacity(.2))
        .clipRRect(all: 10);
  }
}

Future<PlatformCameraController?> getCameraController() async {
  return Platform.isMacOS
      ? await MacosCameraDelegate.controller()
      : Platform.isWindows
          ? await WindowsCameraDelegate.controller()
          : null;
}
