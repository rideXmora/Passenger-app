

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passenger_app/theme/colors.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Column(
              children: [
                // SvgPicture.asset("assets/logo/logo.svg"),
                Image(
                  image: AssetImage(
                    "assets/logo/logo.png",
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Select your prefered language",
                  style: TextStyle(
                    color: primaryColorDark,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 70,
            ),
            Center(child: LanguageSelectionRadioButton(),),
          ],
        ),
      ),
    );
  }
}

class LanguageSelectionRadioButton extends StatefulWidget {
  LanguageSelectionRadioButton({Key? key}) : super(key: key);

  @override
  _LanguageSelectionRadioButtonState createState() =>
      _LanguageSelectionRadioButtonState();
}

class _LanguageSelectionRadioButtonState
    extends State<LanguageSelectionRadioButton> {
  int selected = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selected = 1;
            });
          },
          child: LanguageBox(
            backgroundColor: selected == 1 ? primaryColor : primaryColorWhite,
            borderColor: primaryColorBlack,
            fontColor: selected == 1 ? primaryColorWhite : primaryColorBlack,
            text: "English",
          ),
        ),
        SizedBox(
          height: 25,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              selected = 2;
            });
          },
          child: LanguageBox(
            backgroundColor: selected == 2 ? primaryColor : primaryColorWhite,
            borderColor: primaryColorBlack,
            fontColor: selected == 2 ? primaryColorWhite : primaryColorBlack,
            text: "Sinhala",
          ),
        ),
        SizedBox(
          height: 25,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              selected = 3;
            });
          },
          child: LanguageBox(
            backgroundColor: selected == 3 ? primaryColor : primaryColorWhite,
            borderColor: primaryColorBlack,
            fontColor: selected == 3 ? primaryColorWhite : primaryColorBlack,
            text: "Tamil",
          ),
        ),
      ],
    );
  }
}

class LanguageBox extends StatelessWidget {
  LanguageBox({
    Key? key,
    required this.backgroundColor,
    required this.borderColor,
    required this.text,
    required this.fontColor,
  }) : super(key: key);

  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        color: backgroundColor,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 11,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: fontColor,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
