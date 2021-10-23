import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:passenger_app/pages/bottom_navigation_bar_handler.dart';
import 'package:passenger_app/pages/splash_screen.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/utils/local_string.dart';

import 'controllers/app_binding.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RideX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        backgroundColor: primaryColorWhite,
      ),
      //home: GettingStartedScreen(),
      translations: LocalString(),
      locale: Locale('en', 'US'),
      initialBinding: AppBinding(),
      home: SplashScreen(),
    );
  }
}
