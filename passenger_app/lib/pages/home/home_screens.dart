import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:passenger_app/controllers/controller.dart';
import 'package:passenger_app/controllers/user_controller.dart';
import 'package:passenger_app/pages/home/map_screens/pages/map_screen.dart';
import 'package:passenger_app/pages/home/home_screens/pages/home_screen.dart';
import 'package:passenger_app/pages/home/home_screens/pages/search_location_screen.dart';
import 'package:passenger_app/widgets/dialog_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreens extends StatefulWidget {
  HomeScreens({Key? key}) : super(key: key);

  @override
  _HomeScreensState createState() => _HomeScreensState();
}

TextEditingController whereController = TextEditingController();
bool search = false;
bool map = false;
bool dialogBox = false;
bool loading = false;

class _HomeScreensState extends State<HomeScreens> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // if (map && tripState == TripState.TRIPCOMPLETED) {
        if (map) {
          setState(() {
            map = false;
          });
        } else if (search) {
          setState(() {
            search = false;
          });
        } else {
          debugPrint("as");
          setState(() {
            dialogBox = !dialogBox;
          });
        }
        return false;
      },
      child: Stack(
        children: [
          Stack(
            children: [
              Center(
                child: HomeScreen(
                  onTap: () {
                    setState(() {
                      search = true;
                    });
                    Get.find<Controller>().increment();
                  },
                ),
              ),
              dialogBox
                  ? DialogBox(
                      topic: "Do you really want quit?",
                      loading: loading,
                      onTap: () {
                        if (!loading) {
                          setState(() {
                            dialogBox = false;
                          });
                        }
                      },
                      onNo: () {
                        if (!loading) {
                          setState(() {
                            dialogBox = false;
                          });
                        }
                      },
                      onYes: () async {
                        if (!loading) {
                          setState(() {
                            loading = true;
                          });
                          await Future.delayed(Duration(seconds: 2));
                          SystemNavigator.pop();
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                    )
                  : Container(),
            ],
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
