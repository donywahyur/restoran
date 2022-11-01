class ListRestoranModel {
  List<Data>? data;
  int? total;

  ListRestoranModel({this.data, this.total});

  ListRestoranModel.fromJson(Map<String, dynamic> json) {
    if (json['restaurants'] != null) {
      data = <Data>[];
      json['restaurants'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    total = json['count'];
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
