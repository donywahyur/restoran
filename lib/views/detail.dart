import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import "package:restoran/controllers/detailRestoranController.dart";
import "package:restoran/controllers/favoriteRestoranController.dart";
import "package:restoran/controllers/listRestoranController.dart";
import 'package:get/get.dart';

import 'dart:convert';
import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class Detail extends StatefulWidget {
  final idRestoran;

  Detail({Key? key, required this.idRestoran}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isConnected = true;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
            setState(() => isConnected = false);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isDeviceConnected || isConnected == true) {
      Get.delete<detailRestoranController>();
    }
    detailRestoranController dataController =
        Get.put(detailRestoranController(idRestoran: widget.idRestoran));
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      color: Color.fromARGB(255, 255, 252, 252),
      child: SingleChildScrollView(
          child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() => dataController.isDataLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  child: Column(
                    children: [
                      Container(
                        height: 220,
                        child: Stack(
                            alignment: Alignment.topCenter,
                            textDirection: TextDirection.rtl,
                            fit: StackFit.loose,
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Positioned(
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://restaurant-api.dicoding.dev/images/medium/${dataController.restoranModel?.detail?[3]}"),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              Positioned(
                                top: 170,
                                right: 30,
                                width: 50,
                                height: 50,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    onPressed: () {
                                      dataController.changeFavorite(
                                          dataController
                                              .restoranModel?.detail?[5],
                                          dataController
                                              .restoranModel?.detail?[0]);
                                      // debugPrint(jsonEncode(
                                      //     dataController.listFavorite));
                                    },
                                    child: Icon(
                                      dataController.isFavorite.value
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dataController.restoranModel!.detail![0],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    overflow: TextOverflow.clip),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 15,
                                    ),
                                    Text(
                                      dataController.restoranModel?.detail![2],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                          overflow: TextOverflow.clip),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 15,
                                    ),
                                    Text(
                                      dataController.restoranModel!.detail![4]
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                          overflow: TextOverflow.clip),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                dataController.restoranModel?.detail![1],
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                    overflow: TextOverflow.clip),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.all(15),
                          child: Text("Makanan",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemCount:
                              dataController.restoranModel?.makanan!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Container(
                            width: 100,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  side: BorderSide(
                                      width: 1.0, color: Colors.black),
                                ),
                                onPressed: () {},
                                child: Center(
                                  child: Text(
                                    "${dataController.restoranModel?.makanan![index].nama}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13),
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.all(15),
                          child: Text("Minuman",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold))),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          itemCount:
                              dataController.restoranModel?.minuman?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Container(
                            width: 100,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  side: BorderSide(
                                      width: 1.0, color: Colors.black),
                                ),
                                onPressed: () {},
                                child: Center(
                                  child: Text(
                                    "${dataController.restoranModel?.minuman![index].nama}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      )),
    ));
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Tidak Ada Koneksi Internet'),
          content: const Text('Harap cek koneksi internet anda'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}

class menu extends StatelessWidget {
  final dataController;

  const menu({Key? key, @required this.dataController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(15),
              child: Text("${dataController.restoranModel?.makanan?[0].nama} ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),
          SizedBox(
            height: 80,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(left: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shadowColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Makanan " + index.toString(),
                      style: TextStyle(color: Colors.black),
                    )),
              ),
            ),
          ),
          Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(15),
              child: Text("Minuman",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))),
          SizedBox(
            height: 80,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(left: 10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shadowColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: Text(
                      "Minuman " + index.toString(),
                      style: TextStyle(color: Colors.black),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class detailRestoran extends StatelessWidget {
  const detailRestoran({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://restaurant-api.dicoding.dev/images/medium/14"),
                      fit: BoxFit.cover)),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 170, minHeight: 100),
              margin: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Restaurant Name",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        overflow: TextOverflow.ellipsis),
                  ),
                  Text(
                    "Restaurant Rating",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    "Restaurant Address",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
