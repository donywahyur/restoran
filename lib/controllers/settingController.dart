import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingController extends GetxController {
  var storage = GetStorage();
  var isNotification = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  getNotification() async {
    if (await storage.read('notification') != null) {
      isNotification.value = storage.read('notification');
    }
  }
}
