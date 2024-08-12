import 'package:flutter_barcode_sdk/flutter_barcode_sdk.dart';

class QR {
  QR._();
  FlutterBarcodeSdk? _barcodeReader;
  static final QR instance = QR._();
  static FlutterBarcodeSdk get sdk => instance._barcodeReader!;

  Future<void> ensureInitialized() async {
    if (_barcodeReader == null) {
      _barcodeReader = FlutterBarcodeSdk();
      await _barcodeReader!.setLicense(
          'DLS2eyJoYW5kc2hha2VDb2RlIjoiMjAwMDAxLTE2NDk4Mjk3OTI2MzUiLCJvcmdhbml6YXRpb25JRCI6IjIwMDAwMSIsInNlc3Npb25QYXNzd29yZCI6IndTcGR6Vm05WDJrcEQ5YUoifQ==');
      await _barcodeReader!.init();
    }
  }
}
