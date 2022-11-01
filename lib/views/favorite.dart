import "package:flutter/material.dart";
import "package:restoran/views/detail.dart";
import "package:restoran/views/daftar.dart";
import "package:restoran/views/setting.dart";

import 'package:restoran/controllers/favoriteRestoranController.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'dart:convert';
import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

//create statelesswidget
class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isInternet = true;

  @override
  void initState() {
    super.initState();
    // print('favorit');
    getConnectivity();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
            setState(() => isInternet = false);
          } else {
            setState(() => isInternet = true);
            setState(() => isAlertSet = false);
          }
          // print(isInternet);
          // if (isInternet && isDeviceConnected) {
          //   dataController.getApi();
          // }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // favoriteRestoranController dataController = Get.put(favoriteRestoranController());

    if (isDeviceConnected || isInternet == true) {
      Get.delete<favoriteRestoranController>();
    }
    favoriteRestoranController dataController =
        Get.put(favoriteRestoranController());
    int currentPageIndex = 1;
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        onDestinationSelected: (int index) {
          if (index != currentPageIndex) {
            Get.delete<favoriteRestoranController>();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        [Daftar(), Daftar(), Setting()][index]));
          }
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Restaurant',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
      body: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10, right: 10, top: 25),
                child: Text(
                  "Favorite",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                ),
              ),
              isInternet
                  ? Obx(() => dataController.isDataLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : dataController.listFavorite.length > 0
                          ? Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: dataController.restoranModel!.total,
                                itemBuilder: (context, index) {
                                  if (dataController.listFavorite
                                          .where((ele) =>
                                              ele["id"] ==
                                              dataController.restoranModel!
                                                  .data![index].id)
                                          .length >
                                      0) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.deleteAll();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Detail(
                                                    idRestoran: dataController
                                                        .restoranModel!
                                                        .data![index]
                                                        .id))).then(
                                            (value) => setState(() {
                                                  // print(value);
                                                }));
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(
                                            bottom: 5, left: 10, right: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 120,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          "https://restaurant-api.dicoding.dev/images/medium/" +
                                                              dataController
                                                                  .restoranModel!
                                                                  .data![index]
                                                                  .picRestoran!),
                                                      fit: BoxFit.cover)),
                                            ),
                                            Expanded(
                                              child: Container(
                                                constraints: BoxConstraints(
                                                    minHeight: 100),
                                                margin:
                                                    EdgeInsets.only(left: 20),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      dataController
                                                          .restoranModel!
                                                          .data![index]
                                                          .namaRestoran!,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5, right: 10),
                                                      child: Row(children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.yellow,
                                                          size: 20,
                                                        ),
                                                        Text(
                                                          double.parse(dataController
                                                                  .restoranModel!
                                                                  .data![index]
                                                                  .ratingRestoran!)
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      height: 40,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.location_on,
                                                            color: Colors.red,
                                                            size: 15,
                                                          ),
                                                          Text(
                                                            dataController
                                                                .restoranModel!
                                                                .data![index]
                                                                .kotaRestoran!,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            )
                          : nothing())
                  : Container()
            ],
          ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
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
                  setState(() => isInternet = false);
                } else {
                  setState(() => isInternet = true);
                  setState(() => isAlertSet = false);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}

class nothing extends StatelessWidget {
  const nothing({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.close,
                color: Colors.black,
                size: 50,
              ),
              Text(
                "List Favorite Kosong",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                    overflow: TextOverflow.clip),
              ),
            ],
          )),
    );
  }
}
