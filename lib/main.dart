import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restoran/views/daftar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restoran/controllers/notificationController.dart';

void main() {
  GetStorage.init();
  NotificationController notificationController = NotificationController();
  notificationController.InitializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Daftar(),
    );
  }
}
