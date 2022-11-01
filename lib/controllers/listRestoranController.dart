import 'dart:convert';

import 'package:restoran/models/listRestoranModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class listRestoranController extends GetxController {
  ListRestoranModel? restoranModel;

  var isDataLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    getApi();
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

        restoranModel = ListRestoranModel.fromJson(result);
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
