import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passenger_app/pages/sign_in_up/pages/language_selection_screen.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/widgets/circular_loading.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    load();
  }

  Future<dynamic> load() async {
    await Future.delayed(Duration(seconds: 2)).then((value) {
      Get.offAll(LanguageSelectionScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                "assets/logo/logo.png",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CircularLoading(),
          ],
        ),
      ),
    );
  }
}
