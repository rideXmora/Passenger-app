import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passenger_app/pages/language_selection_screen.dart';
import 'package:passenger_app/pages/registration_screen.dart';
import 'package:passenger_app/theme/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorWhite,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => LanguageSelectionScreen()));
        },
        child: Center(
          child: Image(
            image: AssetImage(
              "assets/logo/logo.png",
            ),
          ),
        ),
      ),
    );
  }
}
