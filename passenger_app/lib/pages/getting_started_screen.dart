import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:passenger_app/theme/colors.dart';

class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({Key? key}) : super(key: key);

  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  bool edit = true;
  String dropdownValue = "+94";
  TextEditingController mobileNumberController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: primaryColorWhite,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 45,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Let's get started now",
                    style: TextStyle(
                      color: primaryColorDark,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 90,
                  ),
                  // CustomTextField(
                  //   readOnly: edit ? false : true,
                  //   height: height,
                  //   width: width,
                  //   controller: mobileController,
                  //   hintText: "Mobile",
                  //   prefixBoxColor: primaryColorBlack,
                  //   prefixIcon: Icon(
                  //     Icons.admin_panel_settings,
                  //     color: primaryColorLight,
                  //   ),
                  //   dropDown: SizedBox(),
                  //   onChanged: () {},
                  //   phoneNumberPrefix: SizedBox(),
                  //   suffix: SizedBox(),
                  // ),
                  CustomTextField(
                    readOnly: edit ? false : true,
                    height: height,
                    width: width,
                    controller: mobileNumberController,
                    hintText: "Mobile Number",
                    prefixBoxColor: primaryColorBlack,
                    prefixIcon: Icon(
                      Icons.phone,
                      color: primaryColorLight,
                    ),
                    dropDown: SizedBox(),
                    keyboardType: TextInputType.number,
                    onChanged: () {},
                    phoneNumberPrefixWidth: 110,
                    inputFormatters: [
                      MaskedInputFormatter("## ### ####",
                          anyCharMatcher: RegExp(r'\d')),
                    ],
                    phoneNumberPrefix: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        IgnorePointer(
                          ignoring: edit ? false : true,
                          child: DropdownButton<String>(
                            underline: SizedBox(),
                            value: dropdownValue,
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: primaryColorWhite,
                            ),
                            style: TextStyle(
                              color: primaryColorWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue.toString();
                              });
                            },
                            dropdownColor: primaryColorLight,
                            items: <String>['+94', '+34']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: primaryColorWhite,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(top: 13.0, bottom: 13.0),
                          child: VerticalDivider(
                            color: primaryColorWhite,
                            width: 1,
                          ),
                        ),
                      ],
                    ),
                    suffix: SizedBox(),
                  ),
                  SizedBox(
                    height: 90,
                  ),
                  MainButton(
                    loading: loading,
                    width: width,
                    height: height,
                    onPressed: () async {
                      if (!loading) {
                        setState(() {
                          loading = true;
                        });

                        // await addInstructor(context);
                        debugPrint(dropdownValue.trim() +
                            mobileNumberController.text.replaceAll(" ", ""));
                        Future.delayed(Duration(seconds: 3)).then((value) {
                          setState(() {
                            loading = false;
                          });
                        });
                      }
                    },
                    text: "CONTINUE",
                    boxColor: primaryColorDark,
                    shadowColor: primaryColorDark,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
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

class MainButton extends StatelessWidget {
  MainButton({
    required this.width,
    required this.height,
    required this.onPressed,
    required this.text,
    this.loading = false,
    required this.boxColor,
    required this.shadowColor,
  });

  final double width;
  final double height;
  var onPressed;
  final String text;
  final bool loading;
  final Color boxColor;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: shadowColor.withOpacity(0.06),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      // ignore: deprecated_member_use
      child: RaisedButton(
        child: loading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(primaryColorWhite),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: primaryColorWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: boxColor,
        textColor: primaryColorWhite,
        onPressed: loading ? () {} : onPressed,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  CustomTextField({
    required this.height,
    required this.width,
    required this.controller,
    this.obscureText = false,
    required this.suffix,
    required this.hintText,
    required this.prefixIcon,
    required this.prefixBoxColor,
    required this.phoneNumberPrefix,
    this.keyboardType = TextInputType.text,
    required this.dropDown,
    this.readOnly = false,
    this.onTap,
    this.phoneNumberPrefixWidth = 38,
    required this.onChanged,
    required this.inputFormatters,
  });

  final double height;
  final double width;
  final TextEditingController controller;
  final bool obscureText;
  final Widget suffix;
  final String hintText;
  final Widget prefixIcon;
  final Color prefixBoxColor;
  final Widget phoneNumberPrefix;
  final TextInputType keyboardType;
  final Widget dropDown;
  final bool readOnly;
  var onTap;
  final double phoneNumberPrefixWidth;
  var onChanged;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 54,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: TextField(
          onTap: onTap,
          style: TextStyle(
            color: primaryColorWhite,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          readOnly: readOnly,
          minLines: 1,
          textAlignVertical: TextAlignVertical.center,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              color: primaryColorWhite.withOpacity(0.5),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                width: phoneNumberPrefixWidth,
                height: 54,
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 48,
                      decoration: BoxDecoration(
                        color: prefixBoxColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: prefixIcon,
                    ),
                    phoneNumberPrefix,
                    dropDown,
                  ],
                ),
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 38,
            ),
          ),
        ),
      ),
    );
  }
}
