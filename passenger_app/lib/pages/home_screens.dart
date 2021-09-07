import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passenger_app/pages/home_screen.dart';
import 'package:passenger_app/pages/map_screen.dart';
import 'package:passenger_app/pages/search_location_screen.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/widgets/custom_text_field.dart';
import 'package:passenger_app/widgets/previous_location.dart';

class HomeScreens extends StatefulWidget {
  HomeScreens({Key? key}) : super(key: key);

  @override
  _HomeScreensState createState() => _HomeScreensState();
}

TextEditingController whereController = TextEditingController();
bool search = false;

class _HomeScreensState extends State<HomeScreens> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HomeScreen(
          onTap: () {
            debugPrint("s");
            setState(() {
              search = true;
            });
          },
        ),
        search
            ? SearchLocationScreen(
                onBack: () {
                  debugPrint("s");
                  setState(() {
                    search = false;
                  });
                },
              )
            : Container(),
        MapScreen(onTap: () {})
      ],
    );
  }
}
