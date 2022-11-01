import 'dart:convert';

import 'package:restoran/models/favoriteRestoranModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class favoriteRestoranController extends GetxController {
  favoriteRestoranModel? restoranModel;

  var isDataLoading = false.obs;
  var listFavorite = [].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    getApi();
    getFavorite();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  getApi() async {
    try {
      isDataLoading(true);
      http.Response response = await http
          .get(Uri.tryParse('https://restaurant-api.dicoding.dev/list')!);
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);

        restoranModel = favoriteRestoranModel.fromJson(result);
        // print(restoranModel);
      } else {
        ///error
        print("Error");
      }
    } catch (e) {
      print('Error while getting data is $e');
    } finally {
      isDataLoading(false);
    }
  }

  getFavorite() async {
    final storage = await GetStorage();
    if (await storage.read('favorite') != null) {
      listFavorite.value = jsonDecode(storage.read('favorite'));
    }
  }
}
