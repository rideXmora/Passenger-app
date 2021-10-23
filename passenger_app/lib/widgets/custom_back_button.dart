import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passenger_app/theme/colors.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: primaryColorDark,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Icon(
          Icons.keyboard_arrow_left_rounded,
          color: primaryColorWhite,
          size: 40,
        )),
      ),
    );
  }
}
