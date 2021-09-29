import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passenger_app/pages/sign_in_up/pages/getting_started_screen.dart';
import 'package:passenger_app/pages/sign_in_up/widgets/language_selection_radio_button.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/widgets/secondary_button_with_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends StatefulWidget {
  LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  int selected = 1;
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                  "Select your prefered language".tr,
                  style: TextStyle(
                    color: primaryColorDark,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: 70,
            ),
            Center(
              child: LanguageSelectionRadioButton(
                selected: selected,
                onTap_1: () async {
                  setState(() {
                    selected = 1;
                  });
                  var locale = Locale('en', 'UK');
                  Get.updateLocale(locale);
                  SharedPreferences store =
                      await SharedPreferences.getInstance();
                  store.setString(
                    "lan",
                    'en_UK',
                  );
                },
                onTap_2: () async {
                  setState(() {
                    selected = 2;
                  });
                  var locale = Locale('si', 'LK');
                  Get.updateLocale(locale);
                  SharedPreferences store =
                      await SharedPreferences.getInstance();
                  store.setString(
                    "lan",
                    'si_LK',
                  );
                },
                onTap_3: () async {
                  setState(() {
                    selected = 3;
                  });
                  var locale = Locale('ta', 'LK');
                  Get.updateLocale(locale);
                  SharedPreferences store =
                      await SharedPreferences.getInstance();
                  store.setString(
                    "lan",
                    'ta_LK',
                  );
                },
              ),
            ),
            SizedBox(
              height: 90,
            ),
            SecondaryButtonWithIcon(
              icon: Icons.arrow_forward_rounded,
              iconColor: primaryColorWhite,
              onPressed: () {
                Get.to(GettingStartedScreen());
                // var locale = Locale('si', 'LK');
                // Get.updateLocale(locale);
              },
              text: "",
              boxColor: primaryColorDark,
              shadowColor: primaryColorDark,
              width: 40,
            )
          ],
        ),
      ),
    );
  }
}
