import 'package:postgrest/postgrest.dart';
import 'package:visitor_solution/utils/constant.dart';
import 'package:visitor_solution/utils/storage.dart';

class Client {
  Client._();
  PostgrestClient? _inner;
  static final _instance = Client._();
  static final instance = _instance._inner!;

  static Future<void> init() async {
    _instance._inner =
        PostgrestClient(postgRestURL(), headers: {}, schema: "public");
  }
}
