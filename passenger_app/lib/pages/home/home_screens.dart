import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:passenger_app/controllers/controller.dart';
import 'package:passenger_app/controllers/map_controller.dart';
import 'package:passenger_app/controllers/ride_controller.dart';
import 'package:passenger_app/controllers/user_controller.dart';
import 'package:passenger_app/pages/home/map_screens/pages/map_screen.dart';
import 'package:passenger_app/pages/home/home_screens/pages/home_screen.dart';
import 'package:passenger_app/pages/home/home_screens/pages/search_location_screen.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/utils/ride_request_state_enum.dart';
import 'package:passenger_app/widgets/circular_loading.dart';
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
bool mapLoading = false;

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
              ? mapLoading
                  ? Scaffold(
                      backgroundColor: primaryColorWhite,
                      body: Center(
                        child: GestureDetector(
                            onTap: () {
                              setState(() {
                                mapLoading = false;
                              });
                            },
                            child: CircularLoading()),
                      ),
                    )
                  : SearchLocationScreen(
                      onBack: () {
                        mapController.clearData();
                        setState(() {
                          search = false;
                        });
                      },
                      toMap: () async {
                        setState(() {
                          mapLoading = true;
                        });
                        bool result1 = await Get.find<MapController>()
                            .getStartPlaceDetails(
                                Get.find<MapController>().start.value.placeId);
                        bool result2 = false;
                        if (result1) {
                          result2 = await Get.find<MapController>()
                              .getEndPlaceDetails(
                                  Get.find<MapController>().to.value.placeId);
                        }
                        Map<String, dynamic> result3 = {"state": false};
                        if (result1 && result2) {
                          result3 = await Get.find<MapController>()
                              .getDirectionDetails(
                            Get.find<MapController>().start.value.location,
                            Get.find<MapController>().to.value.location,
                          );
                        }
                        if (result1 && result2 && result3["state"]) {
                          debugPrint("start: " +
                              Get.find<MapController>()
                                  .start
                                  .value
                                  .location
                                  .toJson()
                                  .toString());
                          debugPrint("end: " +
                              Get.find<MapController>()
                                  .to
                                  .value
                                  .location
                                  .toJson()
                                  .toString());
                          debugPrint("start: " +
                              result3["directionDetails"].toJson().toString());
                          setState(() {
                            Get.find<RideController>().clearRide();
                            Get.find<RideController>()
                                .ride
                                .value
                                .rideRequest
                                .status = RideRequestState.SELECTVECHICLE;
                          });
                          setState(() {
                            mapLoading = false;
                            map = true;
                          });
                        } else {
                          setState(() {
                            mapLoading = false;
                          });
                        }
                      },
                    )
              : Container(),
          map
              ? MapScreen(onBack: () {
                  debugPrint("s");
                  mapController.clearData();
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
