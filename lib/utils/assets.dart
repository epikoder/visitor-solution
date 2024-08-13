import 'package:visitor_solution/utils/constant.dart';

class Assets {
  Assets._();
  static const logo = "assets/images/logo.png";

  static final _instance = Assets._();
  String? _fileServerUrl;
  static String net(String url) {
    _instance._fileServerUrl ??= fileServerURL();
    return "${_instance._fileServerUrl}/$url";
  }
}
