import 'dart:convert';

import 'package:restoran/models/detailRestoranModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class detailRestoranController extends GetxController {
  detailRestoranController({required this.idRestoran});
  final idRestoran;

  detailRestoranModel? restoranModel;

  var isDataLoading = false.obs;
  var isInternetConnection = true.obs;
  var isFavorite = false.obs;
  String dataRes = "";
  final storage = GetStorage();
  var listFavorite = [].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    getApi();
    getFavorite();
    // storage.write("favorite", "[]");
  }

  @override
  void onClose() {}

  getApi() async {
    try {
      isDataLoading(true);
      isInternetConnection(true);
      http.Response response = await http.get(Uri.tryParse(
          'https://restaurant-api.dicoding.dev/detail/' + this.idRestoran)!);
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);

        restoranModel = detailRestoranModel.fromJson(result);
        // print(result);
        // log(result);
        dataRes = "Berhasil asd" + this.idRestoran;
      } else {
        dataRes = "Gagal";

        ///error
        // print("Error");
      }
    } catch (e) {
      dataRes = "Error while getting data is $e";
      print('Error while getting data is $e');
      isInternetConnection(false);
    } finally {
      isDataLoading(false);
    }
  }

  getFavorite() async {
    if (storage.read('favorite') != null) {
      this.listFavorite.value = jsonDecode(storage.read('favorite'));
      if (listFavorite
              .where((element) => element["id"] == this.idRestoran)
              .length >
          0) {
        isFavorite(true);
      } else {
        isFavorite(false);
      }
    } else {
      isFavorite(false);
    }
  }

  changeFavorite(String id, String nama) {
    if (isFavorite.value) {
      //jika sudah favorit
      // listFavorite.remove(id);
      // storage.write('favorite', jsonEncode(this.listFavorite));
      listFavorite.removeWhere((ele) => ele["id"] == id);
      storage.write('favorite', jsonEncode(this.listFavorite));
      isFavorite(false);
    } else {
      //jika belum favorit
      // listFavorite.add(id);
      // storage.write('favorite', jsonEncode(this.listFavorite));
      listFavorite.add({
        "id": id,
        "nama": nama,
      });
      storage.write('favorite', jsonEncode(this.listFavorite));
      isFavorite(true);
    }
  }
}
