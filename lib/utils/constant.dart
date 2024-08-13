import 'package:visitor_solution/utils/storage.dart';

const defaultFileServerUrl = "http://127.0.0.1:8100";
const fileServerKey = "FILESERVER_KEY";

const defaultPostgRestUrl = "http://127.0.0.1:3000";
const postgRestKey = "POSTGREST_KEY";

String fileServerURL() {
  var v = Storage.instance.read<String>(fileServerKey);
  return v != null && v.isNotEmpty ? v : defaultFileServerUrl;
}

String postgRestURL() {
  var v = Storage.instance.read<String>(postgRestKey);
  return v != null && v.isNotEmpty ? v : defaultPostgRestUrl;
}
