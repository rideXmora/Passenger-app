import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

int bottomBarIndex = 1;

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      //backgroundColor: primaryColorWhite,
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        leading: Container(),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
