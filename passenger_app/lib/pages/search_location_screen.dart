import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/widgets/custom_text_field.dart';
import 'package:passenger_app/widgets/previous_location.dart';

class SearchLocationScreen extends StatefulWidget {
  SearchLocationScreen({Key? key, required this.onBack}) : super(key: key);
  final onBack;
  @override
  _SearchLocationScreenState createState() => _SearchLocationScreenState();
}

TextEditingController whereController = TextEditingController();

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primaryColorWhite,
      appBar: AppBar(
        backgroundColor: primaryColorWhite,
        title: Text(
          "Search Location",
          style: TextStyle(
            color: primaryColorBlack,
            fontSize: 23,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: widget.onBack,
          child: Icon(
            Icons.keyboard_arrow_left_sharp,
            size: 30,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 18,
                      ),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: primaryColorDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 4,
                        height: 54,
                        color: primaryColorDark,
                      ),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: primaryColorDark,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 27),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 18,
                          ),
                          CustomTextField(
                            readOnly: false,
                            height: height,
                            width: width,
                            controller: whereController,
                            hintText: "Current location",
                            prefixBoxColor: primaryColorBlack,
                            prefixIcon: Icon(
                              Icons.gps_fixed,
                              color: primaryColorLight,
                            ),
                            dropDown: SizedBox(),
                            onChanged: () {},
                            phoneNumberPrefix: SizedBox(),
                            suffix: SizedBox(),
                            inputFormatters: [],
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          CustomTextField(
                            readOnly: false,
                            height: height,
                            width: width,
                            controller: whereController,
                            hintText: "Where to",
                            prefixBoxColor: primaryColorBlack,
                            prefixIcon: Icon(
                              Icons.location_on_rounded,
                              color: primaryColorLight,
                            ),
                            dropDown: SizedBox(),
                            onChanged: () {},
                            phoneNumberPrefix: SizedBox(),
                            suffix: SizedBox(),
                            inputFormatters: [],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 37, right: 27),
                    child: Column(
                      children: [
                        PreviousLocation(
                          icon: Icons.home_rounded,
                          divider: true,
                          title: "Home",
                          subTitle: "Anandarama Rd, Moratuwa.",
                        ),
                        PreviousLocation(
                          icon: Icons.history,
                          divider: true,
                          title: "Katubedda Bus Stop",
                          subTitle: "Anandarama Rd, Moratuwa.",
                        ),
                        PreviousLocation(
                          icon: Icons.history,
                          divider: true,
                          title: "Katubedda Bus Stop",
                          subTitle: "Anandarama Rd, Moratuwa.",
                        ),
                        PreviousLocation(
                          icon: Icons.history,
                          divider: true,
                          title: "Katubedda Bus Stop",
                          subTitle: "Anandarama Rd, Moratuwa.",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
