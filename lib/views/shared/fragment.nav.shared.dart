import 'package:get/get.dart';

class FragmentNavViewController extends GetxController {
  FragmentNavViewController(String initalRoute) {
    currentRoute.value = initalRoute;
  }
  final currentRoute = "".obs;
}
