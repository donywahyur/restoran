import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<searchRestoranModel> fetchData(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://restaurant-api.dicoding.dev/search?=melting'));

  if (response.statusCode == 200) {
    return searchRestoranModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

class searchRestoranModel {
  List<Data>? data;
  int? total;

  searchRestoranModel({this.data, this.total});

  searchRestoranModel.fromJson(Map<String, dynamic> json) {
    if (json['restaurants'] != null) {
      data = <Data>[];
      json['restaurants'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    total = json['founded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['restaurants'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Data {
  String? id;
  String? namaRestoran;
  String? kotaRestoran;
  String? ratingRestoran;
  String? picRestoran;

  Data(
      {this.id,
      this.namaRestoran,
      this.kotaRestoran,
      this.ratingRestoran,
      this.picRestoran});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaRestoran = json['name'];
    kotaRestoran = json['city'];
    ratingRestoran = json['rating'].toString();
    picRestoran = json['pictureId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.namaRestoran;
    data['city'] = this.kotaRestoran;
    data['rating'] = this.ratingRestoran;
    data['pictureId'] = this.picRestoran;

    return data;
  }
}
