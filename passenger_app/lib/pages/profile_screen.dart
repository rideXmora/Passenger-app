import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passenger_app/theme/colors.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[100],
      //backgroundColor: primaryColorWhite,
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        leading: Container(),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
