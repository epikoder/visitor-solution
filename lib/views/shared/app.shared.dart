import 'package:get/get.dart';

enum AppViewRoute { dashboard, visitors, scan }

class AppViewController extends GetxController {
  final currentRoute = AppViewRoute.dashboard.obs;
  final _loading = false.obs;

  bool get loading => _loading.value;

  void setIsLoading() {
    _loading.value = true;
  }

  void setIsNotLoading() {
    _loading.value = false;
  }
}
