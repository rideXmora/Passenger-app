import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passenger_app/controllers/app_binding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RideX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      initialBinding: AppBinding(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to RideX Passenger APP"),
      ),
      body: Center(
          child: Text(
        "RideX Passenger",
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
        ),
      )),
    );
  }
}
