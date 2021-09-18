import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passenger_app/pages/home_screen.dart';
import 'package:passenger_app/pages/map_screens/map_screen.dart';
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
bool map = false;

class _HomeScreensState extends State<HomeScreens> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (map) {
          setState(() {
            map = false;
          });
        } else if (search) {
          setState(() {
            search = false;
          });
        } else {
          SystemNavigator.pop();
        }
        return false;
      },
      child: Stack(
        children: [
          HomeScreen(
            onTap: () {
              setState(() {
                search = true;
              });
            },
          ),
          search
              ? SearchLocationScreen(
                  onBack: () {
                    setState(() {
                      search = false;
                    });
                  },
                  toMap: () {
                    setState(() {
                      map = true;
                    });
                  },
                )
              : Container(),
          map
              ? MapScreen(onBack: () {
                  debugPrint("s");
                  setState(() {
                    map = false;
                  });
                })
              : Container(),
        ],
      ),
    );
  }
}
