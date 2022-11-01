import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restoran/controllers/searchRestoranController.dart';
import 'package:restoran/views/detail.dart';

import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

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
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  searchRestoranController dataController = Get.put(searchRestoranController());
  @override
  Widget build(BuildContext context) {
    // Generate a list of 100 cards containing a text widget with it's index
    // and render it using a ResponsiveGridList

    return Scaffold(
        body: Container(
            child: Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
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
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: 5, left: 20, right: 20),
          child: Text(
            "Search",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.none),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            onChanged: (value) => {
              Get.delete<searchRestoranController>(),
              value.length > 0
                  ? dataController.getApi(value)
                  : dataController.isSearch(false),
            },
            decoration: InputDecoration(
              hintText: "Search",
              icon: Icon(Icons.search),
              border: InputBorder.none,
            ),
          ),
        ),
        Obx(() => dataController.isSearch.value
            ? dataController.isDataLoading.value
                ? loading()
                : dataController.restoranModel!.total! > 0
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: dataController.restoranModel!.total,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  dataController.isDataLoading.value = true;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => new Detail(
                                              idRestoran: dataController
                                                  .restoranModel!
                                                  .data![index]
                                                  .id)));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
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
                                          constraints:
                                              BoxConstraints(minHeight: 100),
                                          margin: EdgeInsets.only(left: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dataController.restoranModel!
                                                    .data![index].namaRestoran!,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    decoration:
                                                        TextDecoration.none,
                                                    overflow:
                                                        TextOverflow.ellipsis),
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
                                                          TextDecoration.none,
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                              Container(
                                                alignment: Alignment.bottomLeft,
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
                                                              FontWeight.bold,
                                                          color: Colors.black,
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
                            }),
                      )
                    : nothing()
            : cariAwal())
      ],
    )));
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

class loading extends StatelessWidget {
  const loading({
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
                Icons.search,
                color: Colors.black,
                size: 50,
              ),
              Text(
                "Sedang mencari restoran",
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
                "Tidak ada restoran yang ditemukan",
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

class cariAwal extends StatelessWidget {
  const cariAwal({
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
                Icons.search,
                color: Colors.black,
                size: 50,
              ),
              Text(
                "Cari restoran yang anda inginkan",
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
