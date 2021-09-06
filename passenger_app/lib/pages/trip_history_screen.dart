import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TripHistoryScreen extends StatefulWidget {
  TripHistoryScreen({Key? key}) : super(key: key);

  @override
  _TripHistoryScreenState createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      //backgroundColor: primaryColorWhite,
      appBar: AppBar(
        title: Text("Trip History"),
        centerTitle: true,
        leading: Container(),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
