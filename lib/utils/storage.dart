import 'package:get_storage/get_storage.dart';

class Storage {
  Storage._();
  GetStorage? _inner;
  static final _instance = Storage._();
  static final instance = _instance._inner!;

  static Future<void> init() async {
    _instance._inner = GetStorage();
  }
}
