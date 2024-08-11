import 'dart:io';
import 'package:flutter/cupertino.dart';
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
      Visibility(
          visible: file != null,
          child: [
            StyledIconButton(
              icon: CupertinoIcons.check_mark,
              onTap: () {
                Navigator.of(context).pop(file);
              },
            ),
            StyledIconButton(
              icon: CupertinoIcons.clear,
              onTap: () async {
                setState(() {
                  file = null;
                });
                await widget.controller.resume();
              },
            ),
          ].toRow()),
      StyledIconButton(
        icon: CupertinoIcons.camera,
        onTap: () async {
          final newFile = await widget.controller.takePicture();
          setState(() {
            file = newFile;
          });
          await widget.controller.pause();
        },
      ),
    ].toRow();
  }

  // Future<void> showImagePreview(BuildContext buildContext) async {
  //   await showCupertinoDialog(
  //     context: buildContext,
  //     builder: (c) => [
  //       StyledIconButton(
  //         icon: CupertinoIcons.check_mark,
  //         onTap: () {
  //           Navigator.of(context).pop(file);
  //         },
  //       ),
  //       StyledIconButton(
  //         icon: CupertinoIcons.clear,
  //         onTap: () async {
  //           setState(() {
  //             file = null;
  //           });
  //           if (widget.pause != null && widget.resume != null) {
  //             await widget.resume!();
  //           }
  //         },
  //       ),
  //     ].toRow(),
  //   );
  // }
}
