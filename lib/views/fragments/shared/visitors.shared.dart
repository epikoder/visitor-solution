import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visitor_solution/models/visitor.model.dart';
import 'package:visitor_solution/utils/client.dart';
import 'package:visitor_solution/utils/logger.dart';
import 'package:visitor_solution/views/components/modal.component.dart';
import 'package:visitor_solution/views/shared/app.shared.dart';

class VisitorsFragmentController extends GetxController {
  final visitors = <Visitor>[].obs;
  final Rx<Visitor?> visitor = Rx(null);
  final loading = true.obs;
  final searchController = TextEditingController();
  final appController = Get.find<AppViewController>();
  final modalController = ModalController();

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 3), () async {
      await load();
      loading.value = false;
    });
    super.onInit();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> load() async {
    appController.setIsLoading();
    try {
      var query = Client.instance.from("visitors").select();
      if (searchController.text.isNotEmpty) {
        query = query.ilike('vid', '${searchController.text}%');
      }
      final vals = await query.order("created_at", ascending: false);
      visitors.value = vals.map((el) => Visitor.fromJson(el)).toList();
    } on SocketException catch (_) {
      Get.showSnackbar(
        const GetSnackBar(
          title: "Remote connection failed",
          message: "Ensure settings is properly configured",
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      logError(e);
    }
    Future.delayed(
        const Duration(milliseconds: 300), appController.setIsNotLoading);
  }

  void selectVisitor(Visitor visitor) {
    this.visitor.value = visitor;
    modalController.closeModal();
    modalController.openModal();
  }

  void resetVisitor() {
    visitor.value = null;
  }

  void search() {
    load();
  }
}
