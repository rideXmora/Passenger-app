import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger_app/controllers/ride_controller.dart';
import 'package:passenger_app/modals/driver.dart';
import 'package:passenger_app/modals/location.dart';
import 'package:passenger_app/pages/home/map_screens/widgets/floating_panel/finding_ride_floating_panel.dart';
import 'package:passenger_app/pages/home/map_screens/widgets/floating_panel/ride_floating_panel.dart';
import 'package:passenger_app/pages/home/map_screens/widgets/floating_panel/select_vechicle_type_floating_panel.dart';
import 'package:passenger_app/pages/home/map_screens/widgets/pop_up/Rate_and_comment.dart';
import 'package:passenger_app/pages/home/map_screens/widgets/pop_up/trip_completed.dart';
import 'package:passenger_app/utils/ride_request_state_enum.dart';
import 'package:passenger_app/utils/ride_state_enum.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/widgets/secondary_button_with_icon.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    Key? key,
    required this.onBack,
  }) : super(key: key);
  final onBack;
  @override
  _MapScreenState createState() => _MapScreenState();
}

Completer<GoogleMapController> _controller = Completer();

final CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

class _MapScreenState extends State<MapScreen> {
  bool loading = false;
  TextEditingController paymentMethod = TextEditingController();
  int slectedMethod = 0;
  List<Map<String, dynamic>> methods = [
    {
      "Icon": Icons.money,
      "method": "Cash Payment",
      "index": 0,
    },
    {
      "Icon": Icons.credit_card,
      "method": "Card Payment",
      "index": 1,
    }
  ];

  Driver driver = Driver(
    image: "a",
    name: "Avishka Rathnavibushana",
    number: "+94711737706",
    vechicleType: "Toyota Corolla",
  );

  RideState rideState = RideState.NOTRIP;
  RideRequestState rideRequest = RideRequestState.NOTRIP;

  int rating = 1;
  TextEditingController comment = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      paymentMethod.text = methods[0]["method"];
      slectedMethod = 0;
    });
  }

  Widget _floatingCollapsed(RideState state, RideRequestState rideRequest) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColorDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(17),
          topRight: Radius.circular(17),
        ),
      ),
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
        bottom: 0,
        top: 24,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                Icons.keyboard_arrow_up,
                color: primaryColorWhite,
                size: 35,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    rideRequest == RideRequestState.SELECTVECHICLE
                        ? "Confirm ride"
                        : rideRequest == RideRequestState.PENDING
                            ? "Finding ride"
                            : state == RideState.ACCEPTED
                                ? "Driver is comming"
                                : state == RideState.ARRIVED
                                    ? "Driver has arrived"
                                    : state == RideState.PICKED
                                        ? "Going to destination"
                                        : rideState == RideState.DROPPED ||
                                                rideState ==
                                                    RideState
                                                        .DRIVERRATEANDCOMMENT
                                            ? "Ride Ended"
                                            : "",
                    style: TextStyle(
                      color: primaryColorWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectVehicleOnPressedPending() async {
    if (!loading) {
      setState(() {
        loading = true;
      });
      bool result = await Get.find<RideController>().rideRequestSending(
        startLocation: Location(
          x: 0,
          y: 0,
        ),
        endLocation: Location(
          x: 10,
          y: 10,
        ),
        distance: 10,
      );
      if (result) {
        setState(() {
          rideRequest = RideRequestState.PENDING;
        });
      }
      setState(() {
        loading = false;
      });
    }
  }

  void selectVehicleOnSelect(String value) {
    setState(() {
      slectedMethod = methods[int.parse(value)]["index"];
    });
  }

  void pendingOnPressedCancel() {
    setState(() {
      rideRequest = RideRequestState.ACCEPTED;
      rideState = RideState.ACCEPTED;
      //real action is cancel as below
      // rideRequest = RideRequestState.NOTRIP;
      // rideState = RideState.NOTRIP;
    });
  }

  void acceptedOnPressedCall() {
    setState(() {
      if (rideState == RideState.ACCEPTED) {
        rideState = RideState.ARRIVED;
      } else {
        rideState = RideState.PICKED;
      }
    });
    // real action is to call driver
  }

  void pickedOnPressedCall() {
    setState(() {
      if (rideState == RideState.PICKED) {
        rideState = RideState.DROPPED;
      } else if (rideState == RideState.DROPPED) {
        rideState = RideState.DRIVERRATEANDCOMMENT;
      } else {
        rideState = RideState.FINISHED;
      }
    });
    // real action is to call driver
  }

  void tripCompletedOnPressed() {
    setState(() {
      rideState = RideState.PASSENGERRATEANDCOMMENT;
    });
  }

  void rateAndCommentOnPressed() {
    setState(() {
      rideState = RideState.CONFIRMED;
      rideState = RideState.NOTRIP;
      rideRequest = RideRequestState.NOTRIP;
      rating = 0;
      comment.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primaryColorWhite,
      appBar: AppBar(
        backgroundColor: primaryColorWhite,
        title: Text(
          "Map",
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
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
              ],
            ),
            rideRequest == RideRequestState.SELECTVECHICLE ||
                    rideRequest == RideRequestState.PENDING ||
                    rideState == RideState.ACCEPTED ||
                    rideState == RideState.ARRIVED ||
                    rideState == RideState.PICKED ||
                    rideState == RideState.DROPPED ||
                    rideState == RideState.DRIVERRATEANDCOMMENT
                ? SlidingUpPanel(
                    renderPanelSheet: false,
                    panel: rideRequest == RideRequestState.SELECTVECHICLE
                        ? SelectVechicleTypeFloatingPanel(
                            paymentMethod: paymentMethod,
                            methods: methods,
                            slectedMethod: slectedMethod,
                            loading: loading,
                            onSelect: selectVehicleOnSelect,
                            onPressed: selectVehicleOnPressedPending,
                          )
                        : rideRequest == RideRequestState.PENDING
                            ? FindingRideFloatingPanel(
                                loading: loading,
                                onPressed: pendingOnPressedCancel,
                              )
                            : rideState == RideState.ACCEPTED ||
                                    rideState == RideState.ARRIVED
                                ? RideFloatingPanel(
                                    driver: driver,
                                    time: "1 min",
                                    rideState: rideState,
                                    loading: loading,
                                    onPressed: acceptedOnPressedCall,
                                  )
                                : rideState == RideState.PICKED ||
                                        rideState == RideState.DROPPED ||
                                        rideState ==
                                            RideState.DRIVERRATEANDCOMMENT
                                    ? RideFloatingPanel(
                                        driver: driver,
                                        time: "1 min",
                                        rideState: rideState,
                                        loading: loading,
                                        onPressed: pickedOnPressedCall,
                                      )
                                    : Container(),
                    collapsed: _floatingCollapsed(rideState, rideRequest),
                    backdropColor: Colors.transparent,
                    defaultPanelState: PanelState.OPEN,
                    maxHeight: rideState == RideState.ACCEPTED ||
                            rideState == RideState.ARRIVED ||
                            rideState == RideState.PICKED ||
                            rideState == RideState.DROPPED ||
                            rideState == RideState.DRIVERRATEANDCOMMENT
                        ? 270
                        : 360,
                  )
                : Container(),
            rideState == RideState.FINISHED
                ? TripCompleted(
                    loading: loading,
                    onPressed: tripCompletedOnPressed,
                  )
                : rideState == RideState.PASSENGERRATEANDCOMMENT
                    ? RateAndComment(
                        loading: loading,
                        onPressed: rateAndCommentOnPressed,
                        rating: rating,
                        onRatingChanged1: () {
                          setState(() {
                            rating = 1;
                          });
                        },
                        onRatingChanged2: () {
                          setState(() {
                            rating = 2;
                          });
                        },
                        onRatingChanged3: () {
                          setState(() {
                            rating = 3;
                          });
                        },
                        onRatingChanged4: () {
                          setState(() {
                            rating = 4;
                          });
                        },
                        onRatingChanged5: () {
                          setState(() {
                            rating = 5;
                          });
                        },
                        comment: comment,
                      )
                    : Container(),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SecondaryButtonWithIcon(
                      icon: Icons.online_prediction,
                      iconColor: primaryColorWhite,
                      onPressed: () {
                        setState(() {
                          rideRequest = RideRequestState.SELECTVECHICLE;
                        });
                      },
                      text: "get ride",
                      boxColor: primaryColorDark,
                      shadowColor: primaryColorDark,
                      width: width,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
