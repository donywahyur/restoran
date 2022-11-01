import 'dart:convert';

import 'package:restoran/models/searchRestoranModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class searchRestoranController extends GetxController {
  searchRestoranModel? restoranModel;

  var isDataLoading = false.obs;
  var isSearch = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    // getApi();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  getApi(String searchQuery) async {
    try {
      isSearch(true);
      isDataLoading(true);
      http.Response response = await http.get(Uri.tryParse(
          'https://restaurant-api.dicoding.dev/search?q=' + searchQuery)!);
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);

        restoranModel = searchRestoranModel.fromJson(result);
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
}
