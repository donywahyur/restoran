class detailRestoranModel {
  List<Data>? makanan;
  List<Data>? minuman;
  List? detail;

  detailRestoranModel({this.detail, this.makanan, this.minuman});

  detailRestoranModel.fromJson(Map<String, dynamic> json) {
    if (json['restaurant']['menus']['foods'] != null) {
      makanan = <Data>[];
      json['restaurant']['menus']['foods'].forEach((v) {
        makanan!.add(new Data.fromJson(v));
      });
    }
    if (json['restaurant']['menus']['drinks'] != null) {
      minuman = <Data>[];
      json['restaurant']['menus']['drinks'].forEach((v) {
        minuman!.add(new Data.fromJson(v));
      });
    }
    detail = [];
    detail!.add(json['restaurant']['name']);
    detail!.add(json['restaurant']['description']);
    detail!.add(json['restaurant']['address']);
    detail!.add(json['restaurant']['pictureId']);
    detail!.add(json['restaurant']['rating']);
    detail!.add(json['restaurant']['id']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.makanan != null) {
      data['makanan'] = this.makanan!.map((v) => v.toJson()).toList();
    }
    if (this.minuman != null) {
      data['minuman'] = this.minuman!.map((v) => v.toJson()).toList();
    }
    data['detail'] = this.detail;
    return data;
  }
}

class Data {
  String? nama;

  Data({this.nama});

  Data.fromJson(Map<String, dynamic> json) {
    nama = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama'] = this.nama;

    return data;
  }
}
