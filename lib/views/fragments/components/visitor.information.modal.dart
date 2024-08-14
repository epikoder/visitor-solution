import 'package:printing/printing.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:visitor_solution/models/gender.model.dart';
import 'package:visitor_solution/models/visitor.model.dart';
import 'package:visitor_solution/utils/assets.dart';
import 'package:visitor_solution/utils/client.dart';
import 'package:visitor_solution/utils/helper.dart';
import 'package:visitor_solution/utils/logger.dart';
import 'package:visitor_solution/views/components/button.component.dart';
import 'package:visitor_solution/views/components/modal.component.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:visitor_solution/views/fragments/shared/visitors.shared.dart';
import 'package:visitor_solution/views/shared/app.shared.dart';

Widget _buildTile(String text, IconData icon) {
  return <Widget>[
    Styled.icon(icon),
    Styled.text(text),
  ].toRow(
    separator: Styled.widget()
        .width(1)
        .height(10)
        .backgroundColor(Colors.grey.shade500)
        .padding(horizontal: 10),
  );
}

Future<Uint8List?> _getImageByte(key) async {
  final render =
      key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (render == null) {
    Get.snackbar("Failed", "Could not print Qr Code",
        duration: const Duration(seconds: 2));
    return null;
  }
  return null;
}

printTag(BuildContext buildContext, Visitor visitor) async {
  final logo = (await rootBundle.load(Assets.logo)).buffer.asUint8List();
  Uint8List? avatar;
  try {
    avatar = (await http.get(Uri.parse(Assets.net(visitor.photo)))).bodyBytes;
  } catch (e) {
    logError(e);
  }
  if (avatar == null) {
    return;
  }
  final doc = pw.Document();
  const width = 300.0;

  final bgColor = PdfColor.fromHex("#ebebeb");
  final now = DateTime.now();
  doc.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Container(
          decoration: pw.BoxDecoration(
            color: bgColor,
          ),
          child: pw.Stack(children: [
            pw.Positioned(
              left: -120,
              top: -200,
              child: pw.Transform(
                  transform:
                      Matrix4.translationValues(width * 0.55, -250.0, 0.0)
                        ..rotateZ(45 * 3.1415927 / 180),
                  child: pw.Container(
                    height: 300,
                    width: 300,
                    color: PdfColors.red,
                  )),
            ),
            pw.Positioned(
              left: -20,
              top: -400,
              child: pw.Transform(
                  transform:
                      Matrix4.translationValues(width * 0.55, -250.0, 0.0)
                        ..rotateZ(7 * 3.1415927 / 180),
                  child: pw.Container(
                    height: 500,
                    width: 600,
                    color: PdfColors.white,
                  )),
            ),
            pw.Positioned(
              left: 10,
              top: -400,
              child: pw.Transform(
                  transform:
                      Matrix4.translationValues(width * 0.55, -250.0, 0.0)
                        ..rotateZ(-60 * 3.1415927 / 180),
                  child: pw.Container(
                    height: 500,
                    width: 300,
                    color: bgColor,
                  )),
            ),
            pw.SizedBox(
              width: double.infinity,
              child: pw.Padding(
                padding: const pw.EdgeInsets.only(
                  top: 20,
                  bottom: 10,
                  left: 50,
                  right: 50,
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  mainAxisSize: pw.MainAxisSize.max,
                  children: [
                    pw.Row(
                      children: [
                        pw.Image(
                          pw.MemoryImage(
                            logo,
                          ),
                          height: 100,
                          width: 100,
                        ),
                      ],
                    ),
                    pw.ClipRRect(
                      horizontalRadius: 20,
                      verticalRadius: 20,
                      child: pw.Image(
                        pw.MemoryImage(avatar!),
                        height: 300,
                        width: 300,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      visitor.vid.toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex("#6d6d6d"),
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              "FULL NAME :",
                              style: pw.TextStyle(
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex("#6d6d6d"),
                              ),
                            ),
                            pw.SizedBox(width: 15),
                            pw.Text(
                              visitor.name,
                              style: pw.TextStyle(
                                fontSize: 24,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          children: [
                            pw.Text(
                              "DEPARTMENT :",
                              style: pw.TextStyle(
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex("#6d6d6d"),
                              ),
                            ),
                            pw.SizedBox(width: 15),
                            pw.Text(
                              visitor.department,
                              style: const pw.TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Row(
                          children: [
                            pw.Text(
                              "PURPOSE :",
                              style: pw.TextStyle(
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex("#6d6d6d"),
                              ),
                            ),
                            pw.SizedBox(width: 15),
                            pw.Text(
                              visitor.purpose.string,
                              style: const pw.TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (visitor.clockedInAt != null)
                      pw.Column(children: [
                        pw.Text(
                          "Checked in on:",
                          style: pw.TextStyle(
                            fontSize: 16,
                            color: PdfColor.fromHex("#6d6d6d"),
                          ),
                        ),
                        pw.Text(
                          datetimeToString(visitor.clockedInAt!,
                              showTime: true),
                          style: pw.TextStyle(
                            fontSize: 16,
                            color: PdfColor.fromHex("#6d6d6d"),
                          ),
                        ),
                      ]),
                    if (visitor.clockedOutAt != null)
                      pw.Column(children: [
                        pw.Text(
                          "Checked Out on:",
                          style: pw.TextStyle(
                            fontSize: 16,
                            color: PdfColor.fromHex("#6d6d6d"),
                          ),
                        ),
                        pw.Text(
                          datetimeToString(visitor.clockedOutAt!,
                              showTime: true),
                          style: pw.TextStyle(
                            fontSize: 16,
                            color: PdfColor.fromHex("#6d6d6d"),
                          ),
                        ),
                      ]),
                    pw.Column(children: [
                      pw.Text(
                        "Generated on:",
                        style: pw.TextStyle(
                          fontSize: 16,
                          color: PdfColor.fromHex("#6d6d6d"),
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        datetimeToString(now, showTime: true),
                        style: pw.TextStyle(
                          fontSize: 16,
                          color: PdfColor.fromHex("#6d6d6d"),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            )
          ]),
        );
      },
    ),
  );

  Printing.layoutPdf(
      name: "${visitor.name}-${DateTime.now().toLocal()}",
      onLayout: (PdfPageFormat format) async => doc.save()).catchError((e, s) {
    logError(e, stackTrace: s);
  });
}

void _clockIn(BuildContext context, Rx<Visitor?> visitor) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (c) => CupertinoAlertDialog(
      title: Styled.text("Clock In"),
      content: Styled.text("Proceed to clock-in this visitor"),
      actions: [
        StyledButton(
          text: "Cancel",
          verticalPadding: 10,
          color: Colors.red.shade500,
          borderRadius: 0,
          onTap: () {
            Navigator.of(c).pop();
          },
        ),
        StyledButton(
          text: "Continue",
          verticalPadding: 10,
          borderRadius: 0,
          onTap: () async {
            Navigator.of(c).pop();
            Get.find<AppViewController>().setIsLoading();
            try {
              final now = DateTime.now();
              await Client.instance.from("visitors").update({
                "clocked_in_at": now.toIso8601String(),
              }).eq("vid", visitor.value!.vid);
              final nv = Visitor.fromJson(visitor.value!.toJson());
              nv.clockedInAt = now;
              visitor.value = nv;
              final controller = Get.find<VisitorsFragmentController>();
              controller.visitors.value = controller.visitors.map((v) {
                if (v.vid == nv.vid) {
                  return nv;
                }
                return v;
              }).toList();
            } catch (e) {
              logError(e);
            }
            Get.find<AppViewController>().setIsNotLoading();
          },
        ),
      ],
    ),
  );
}

void _clockOut(BuildContext context, Rx<Visitor?> visitor) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (c) => CupertinoAlertDialog(
      title: Styled.text("Clock Out"),
      content: Styled.text("Proceed to clock-out this visitor"),
      actions: [
        StyledButton(
          text: "Cancel",
          verticalPadding: 10,
          borderRadius: 0,
          color: Colors.red.shade500,
          onTap: () {
            Navigator.of(c).pop();
          },
        ),
        StyledButton(
          text: "Continue",
          verticalPadding: 10,
          borderRadius: 0,
          onTap: () async {
            Navigator.of(c).pop();
            Get.find<AppViewController>().setIsLoading();
            try {
              final now = DateTime.now();
              await Client.instance.from("visitors").update({
                "clocked_out_at": now.toIso8601String(),
              }).eq("vid", visitor.value!.vid);
              final nv = Visitor.fromJson(visitor.value!.toJson());
              nv.clockedOutAt = now;
              visitor.value = nv;
              final controller = Get.find<VisitorsFragmentController>();
              controller.visitors.value = controller.visitors.map((v) {
                if (v.vid == nv.vid) {
                  return nv;
                }
                return v;
              }).toList();
            } catch (e) {
              logError(e);
            }
            Get.find<AppViewController>().setIsNotLoading();
          },
        ),
      ],
    ),
  );
}

Modal visitorInformationModal(
  BuildContext context,
  ModalController controller,
  Rx<Visitor?> visitor, {
  VoidCallback? onClose,
}) {
  return Modal(
    controller: controller,
    header: ModalHeader(
      title: visitor.value!.name,
      actions: [
        StyledIconButton(
          icon: CupertinoIcons.clear,
          bgColor: Colors.red,
          onTap: () {
            controller.closeModal();
            if (onClose != null) onClose();
          },
        )
      ],
    ),
    body: <Widget>[
      <Widget>[
        CachedNetworkImage(
          imageUrl: Assets.net(visitor.value!.photo),
          imageBuilder: (context, imageProvider) => RepaintBoundary(
            child: CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.transparent,
              backgroundImage: imageProvider,
            ),
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            child: Image.asset(
              Assets.logo,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        )
            .constrained(width: 100, height: 100)
            .backgroundColor(Colors.white)
            .clipRRect(all: 100)
            .padding(all: 5),
        _buildTile(visitor.value!.phone, CupertinoIcons.phone),
        _buildTile(
          visitor.value!.gender.string,
          visitor.value!.gender == Gender.male ? Icons.male : Icons.female,
        ),
        _buildTile(visitor.value!.purpose.string, Icons.mail),
        _buildTile(
          visitor.value!.department,
          Icons.place,
        ),
        Obx(
          () => _buildTile(
              visitor.value!.clockedInAt != null
                  ? datetimeToString(visitor.value!.clockedInAt!,
                      showTime: true)
                  : "-",
              CupertinoIcons.time),
        ),
        Obx(
          () => _buildTile(
              visitor.value!.clockedOutAt != null
                  ? datetimeToString(visitor.value!.clockedOutAt!,
                      showTime: true)
                  : "-",
              Icons.timelapse),
        ),
        const SizedBox(
          height: 20,
        ),
        Button(
          text: "Print Tag",
          icon: Icons.print,
          color: Colors.black,
          verticalPadding: 10,
          horizontalPadding: 20,
          onTap: () => printTag(context, visitor.value!),
        ),
      ]
          .toColumn(
            separator: const SizedBox(
              height: 10,
            ),
          )
          .padding(vertical: 20, horizontal: 30)
          .scrollable()
          .expanded(flex: 1),
      <Widget>[
        Obx(
          () => Button(
            text: 'Clock In',
            icon: CupertinoIcons.timer,
            onTap: visitor.value!.canClockIn
                ? () => _clockIn(context, visitor)
                : null,
            verticalPadding: 10,
          ).center().expanded(flex: 1),
        ),
        Obx(
          () => Button(
            text: 'Clock Out',
            icon: CupertinoIcons.timer,
            onTap: visitor.value!.canClockOut
                ? () => _clockOut(context, visitor)
                : null,
            verticalPadding: 10,
          ).center().expanded(flex: 1),
        ),
      ]
          .toRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            separator: const SizedBox(
              width: 50,
            ),
          )
          .height(50)
          .padding(horizontal: 10)
    ]
        .toColumn()
        .constrained(maxHeight: MediaQuery.of(context).size.height - 50),
  );
}
