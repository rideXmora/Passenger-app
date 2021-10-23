import 'package:flutter/material.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/widgets/simple_icon_text_box.dart';

class HistoryDataBox extends StatelessWidget {
  const HistoryDataBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              gradient: LinearGradient(
                colors: [
                  primaryColorDark,
                  primaryColor,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 28,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "2021 july 12",
                    style: TextStyle(
                      color: primaryColorBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Divider(
                    thickness: 1.5,
                    color: primaryColorBlack,
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              child: Icon(
                                Icons.location_pin,
                                color: primaryColorLight,
                                size: 20,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 20,
                              color: primaryColorLight,
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              child: Icon(
                                Icons.flag,
                                color: primaryColorLight,
                                size: 20,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 30,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pick up location",
                                        style: TextStyle(
                                          color: primaryColorBlack,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "Moratuwa, Sri Lanka",
                                        style: TextStyle(
                                          color: primaryColorWhite,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 30,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Destination",
                                        style: TextStyle(
                                          color: primaryColorBlack,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "Panadura, Sri Lanka",
                                        style: TextStyle(
                                          color: primaryColorWhite,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      bottom: 16,
                    ),
                    child: Center(
                      child: Wrap(
                        runAlignment: WrapAlignment.center,
                        alignment: WrapAlignment.center,
                        spacing: 5,
                        children: [
                          SimpleIconTextBox(
                            icon: Icons.location_on_sharp,
                            text: "0.1 miles",
                          ),
                          SimpleIconTextBox(
                            icon: Icons.timer,
                            text: "1 min",
                          ),
                          SimpleIconTextBox(
                            icon: Icons.attach_money_sharp,
                            text: "250 LKR",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.credit_card, color: primaryColorLight),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Card Payment",
                        style: TextStyle(
                          color: primaryColorWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
