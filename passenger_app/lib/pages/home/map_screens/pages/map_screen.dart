import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:passenger_app/controllers/map_controller.dart';
import 'package:passenger_app/controllers/ride_controller.dart';
import 'package:passenger_app/modals/driver.dart';
import 'package:passenger_app/modals/location.dart';
import 'package:passenger_app/pages/home/home_screens.dart';
import 'package:passenger_app/pages/home/map_screens/widgets/floating_panel/finding_ride_floating_panel.dart';
import 'package:passenger_app/pages/home/map_screens/widgets/floating_panel/ride_floating_panel.dart';
import 'package:passenger_app/pages/home/map_screens/widgets/floating_panel/select_vechicle_type_floating_panel.dart';
import 'package:passenger_app/pages/home/map_screens/widgets/pop_up/Rate_and_comment.dart';
import 'package:passenger_app/pages/home/map_screens/widgets/pop_up/trip_completed.dart';
import 'package:passenger_app/utils/firebase_notification_handler.dart';
import 'package:passenger_app/utils/ride_request_state_enum.dart';
import 'package:passenger_app/utils/ride_state_enum.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/utils/vehicle_type.dart';
import 'package:passenger_app/widgets/circular_loading.dart';
import 'package:passenger_app/widgets/secondary_button_with_icon.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:sockjs_client_wrapper/sockjs_client_wrapper.dart';
// import "package:stomp/stomp.dart";
// import "package:stomp/vm.dart" show connect;
import 'dart:convert';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    Key? key,
    required this.onBack,
  }) : super(key: key);
  final onBack;
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool loading = false;
  bool loadingGreen = false;
  bool loadingRed = false;
  bool complain = false;

  TextEditingController paymentMethod = TextEditingController();
  int slectedMethod = 0;
  List<Map<String, dynamic>> methods = [
    {
      "Icon": Icons.money,
      "method": "Cash Payment",
      "index": 0,
    },
    // {
    //   "Icon": Icons.credit_card,
    //   "method": "Card Payment",
    //   "index": 1,
    // }
  ];

  // RideState rideState = RideState.NOTRIP;
  // RideRequestState rideRequest = RideRequestState.NOTRIP;

  int rating = 1;
  TextEditingController comment = TextEditingController();

  MapController mapController = Get.find<MapController>();
  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // late Position currentPosition;
  // Future<void> locatePosition() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   currentPosition = position;

  //   LatLng latLastPosition = LatLng(position.latitude, position.longitude);

  //   CameraPosition cameraPosition =
  //       CameraPosition(target: latLastPosition, zoom: 14);

  //   newGoogleMapController
  //       .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  //   String address =
  //       await Get.find<MapController>().searchCoordinateAddress(position);
  //   debugPrint("My address: " + address);
  // }

  @override
  void initState() {
    super.initState();
    setState(() {
      paymentMethod.text = methods[0]["method"];
      slectedMethod = 0;
    });
  }

  // void onConnect(StompFrame frame) {
  //   var sname = "+94763067706";
  //   stompClient.subscribe(
  //     destination: "/user/" + sname + "/queue/messages",
  //     callback: (frame) {
  //       List<dynamic>? result = json.decode(frame.body!);
  //       print(result);
  //     },
  //   );

  // Timer.periodic(Duration(seconds: 10), (_) {
  //   const message = {
  //     "senderPhone": "sname",
  //     "receiverPhone": "rname",
  //     "location": {"x": 1.2222, "y": 2.444},
  //   };
  //   stompClient.send(
  //     destination: '/app/chat',
  //     body: json.encode(message),
  //   );
  // });
  // }

  var stompClient;

  Widget _floatingCollapsed() {
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
                  child: Obx(
                    () => Text(
                      Get.find<RideController>()
                                  .ride
                                  .value
                                  .rideRequest
                                  .status ==
                              RideRequestState.SELECTVECHICLE
                          ? "Confirm ride"
                          : Get.find<RideController>()
                                      .ride
                                      .value
                                      .rideRequest
                                      .status ==
                                  RideRequestState.PENDING
                              ? "Finding ride"
                              : Get.find<RideController>()
                                          .ride
                                          .value
                                          .rideStatus ==
                                      RideState.ACCEPTED
                                  ? "Driver is comming"
                                  : Get.find<RideController>()
                                              .ride
                                              .value
                                              .rideStatus ==
                                          RideState.ARRIVED
                                      ? "Driver has arrived"
                                      : Get.find<RideController>()
                                                  .ride
                                                  .value
                                                  .rideStatus ==
                                              RideState.PICKED
                                          ? "Going to destination"
                                          : Get.find<RideController>()
                                                          .ride
                                                          .value
                                                          .rideStatus ==
                                                      RideState.DROPPED ||
                                                  Get.find<RideController>()
                                                          .ride
                                                          .value
                                                          .rideStatus ==
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectVehicleOnPressedToPending() async {
    if (!loadingGreen) {
      setState(() {
        loadingGreen = true;
      });
      debugPrint(Get.find<RideController>().vehicleType.value.toString());
      bool result = await Get.find<RideController>().rideRequestSending(
        startLocation: mapController.start.value.location,
        endLocation: mapController.to.value.location,
        distance: mapController.directionDetails.value.distanceValue.toDouble(),
        vehicleType: Get.find<RideController>().vehicleType.value,
      );
      setState(() {
        loadingGreen = false;
      });
    }
  }

  void selectVehicleOnSelect(String value) {
    setState(() {
      slectedMethod = methods[int.parse(value)]["index"];
    });
  }

  void pendingOnPressedToCancel() async {
    if (!loadingGreen) {
      setState(() {
        loadingGreen = true;
      });
      await Get.find<RideController>().rideCancel();

      setState(() {
        loadingGreen = false;
      });

      widget.onBack();
    }
  }

  void acceptedOnPressedToCall() async {
    if (!loadingGreen) {
      setState(() {
        loadingGreen = true;
      });
      String phone =
          Get.find<RideController>().ride.value.rideRequest.driver.phone;
      await canLaunch("tel:$phone")
          ? await launch("tel:$phone")
          : Get.snackbar("Somethimg is wrong!", "Please try again later.");
      setState(() {
        loadingGreen = false;
      });
    }
  }

  void pickedOnPressedToCall() async {
    if (!loadingGreen) {
      setState(() {
        loadingGreen = true;
      });
      String phone =
          Get.find<RideController>().ride.value.rideRequest.driver.phone;
      await canLaunch("tel:$phone")
          ? await launch("tel:$phone")
          : Get.snackbar("Somethimg is wrong!", "Please try again later.");
      setState(() {
        loadingGreen = false;
      });
    }
  }

  void tripCompletedOnPressed() {
    if (!loadingGreen) {
      setState(() {
        loadingGreen = true;
      });
      Get.find<RideController>().rideComplete();

      setState(() {
        loadingGreen = false;
      });
    }
  }

  void rateAndCommentOnPressed() async {
    if (!loadingGreen) {
      setState(() {
        loadingGreen = true;
      });
      bool result = await Get.find<RideController>().rideConfirmed(
        passengerFeedback: comment.text,
        driverRating: rating,
        complainBool: complain,
      );

      setState(() {
        loadingGreen = false;
        comment.text = "";
        rating = 1;
      });
      widget.onBack();
    }
  }

  void rateAndCommentOnCancel() async {
    if (!loadingRed) {
      setState(() {
        loadingRed = true;
      });
      bool result = await Get.find<RideController>().rideConfirmed(
        passengerFeedback: "",
        driverRating: 0,
        complainBool: false,
      );

      setState(() {
        loadingRed = false;
      });
      widget.onBack();
    }
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
                  child: Obx(
                    () => GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        Completer<GoogleMapController> _controllerGoogleMap =
                            Completer();
                        _controllerGoogleMap.complete(controller);
                        mapController.newGoogleMapController = controller;

                        //locatePosition();
                        mapController.setPolyLines();
                      },
                      polylines: mapController.polyLineSet.value,
                      markers: mapController.markersSet.value,
                      circles: mapController.circlesSet.value,
                    ),
                  ),
                ),
              ],
            ),
            Obx(
              () => Get.find<RideController>().ride.value.rideRequest.status ==
                          RideRequestState.SELECTVECHICLE ||
                      Get.find<RideController>()
                              .ride
                              .value
                              .rideRequest
                              .status ==
                          RideRequestState.PENDING ||
                      Get.find<RideController>().ride.value.rideStatus ==
                          RideState.ACCEPTED ||
                      Get.find<RideController>().ride.value.rideStatus ==
                          RideState.ARRIVED ||
                      Get.find<RideController>().ride.value.rideStatus ==
                          RideState.PICKED ||
                      Get.find<RideController>().ride.value.rideStatus ==
                          RideState.DROPPED ||
                      Get.find<RideController>().ride.value.rideStatus ==
                          RideState.DRIVERRATEANDCOMMENT
                  ? SlidingUpPanel(
                      renderPanelSheet: false,
                      panel: Get.find<RideController>()
                                  .ride
                                  .value
                                  .rideRequest
                                  .status ==
                              RideRequestState.SELECTVECHICLE
                          ? SelectVechicleTypeFloatingPanel(
                              paymentMethod: paymentMethod,
                              methods: methods,
                              slectedMethod: slectedMethod,
                              loading: loadingGreen,
                              onSelect: selectVehicleOnSelect,
                              onPressed: selectVehicleOnPressedToPending,
                            )
                          : Get.find<RideController>()
                                      .ride
                                      .value
                                      .rideRequest
                                      .status ==
                                  RideRequestState.PENDING
                              ? FindingRideFloatingPanel(
                                  loading: loadingGreen,
                                  onPressed: pendingOnPressedToCancel,
                                )
                              : Get.find<RideController>()
                                              .ride
                                              .value
                                              .rideStatus ==
                                          RideState.ACCEPTED ||
                                      Get.find<RideController>()
                                              .ride
                                              .value
                                              .rideStatus ==
                                          RideState.ARRIVED
                                  ? RideFloatingPanel(
                                      driver: Get.find<RideController>()
                                          .ride
                                          .value
                                          .rideRequest
                                          .driver,
                                      time: "",
                                      rideState: Get.find<RideController>()
                                          .ride
                                          .value
                                          .rideStatus,
                                      loading: loadingGreen,
                                      onPressed: acceptedOnPressedToCall,
                                    )
                                  : Get.find<RideController>()
                                                  .ride
                                                  .value
                                                  .rideStatus ==
                                              RideState.PICKED ||
                                          Get.find<RideController>()
                                                  .ride
                                                  .value
                                                  .rideStatus ==
                                              RideState.DROPPED ||
                                          Get.find<RideController>()
                                                  .ride
                                                  .value
                                                  .rideStatus ==
                                              RideState.DRIVERRATEANDCOMMENT
                                      ? RideFloatingPanel(
                                          driver: Get.find<RideController>()
                                              .ride
                                              .value
                                              .rideRequest
                                              .driver,
                                          time: "",
                                          rideState: Get.find<RideController>()
                                              .ride
                                              .value
                                              .rideStatus,
                                          loading: loadingGreen,
                                          onPressed: pickedOnPressedToCall,
                                        )
                                      : Container(),
                      collapsed: _floatingCollapsed(),
                      backdropColor: Colors.transparent,
                      defaultPanelState: PanelState.OPEN,
                      maxHeight:
                          Get.find<RideController>().ride.value.rideStatus ==
                                      RideState.ACCEPTED ||
                                  Get.find<RideController>()
                                          .ride
                                          .value
                                          .rideStatus ==
                                      RideState.ARRIVED ||
                                  Get.find<RideController>()
                                          .ride
                                          .value
                                          .rideStatus ==
                                      RideState.PICKED ||
                                  Get.find<RideController>()
                                          .ride
                                          .value
                                          .rideStatus ==
                                      RideState.DROPPED ||
                                  Get.find<RideController>()
                                          .ride
                                          .value
                                          .rideStatus ==
                                      RideState.DRIVERRATEANDCOMMENT
                              ? 270
                              : 360,
                    )
                  : Container(),
            ),
            Obx(
              () => Get.find<RideController>().ride.value.rideStatus ==
                      RideState.FINISHED
                  ? TripCompleted(
                      loading: loading,
                      onPressed: tripCompletedOnPressed,
                      trip: mapController.directionDetails.value,
                      pickUp: mapController.start.value.getLocationText(),
                      dropOff: mapController.to.value.getLocationText(),
                      payment: Get.find<RideController>().ride.value.payment,
                    )
                  : Get.find<RideController>().ride.value.rideStatus ==
                          RideState.PASSENGERRATEANDCOMMENT
                      ? RateAndComment(
                          greenTopic: "Submit",
                          loadingGreen: loadingGreen,
                          redTopic: "Cancel",
                          loadingRed: loadingRed,
                          onPressed: rateAndCommentOnPressed,
                          onCancel: rateAndCommentOnCancel,
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
                          complain: complain,
                          onComplain: (value) {
                            setState(() {
                              complain = !complain;
                            });
                            debugPrint(complain.toString());
                          })
                      : Container(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10),
                  //   child: SecondaryButtonWithIcon(
                  //     icon: Icons.online_prediction,
                  //     iconColor: primaryColorWhite,
                  //     onPressed: () async {
                  //       setState(() {
                  //         Get.find<RideController>().clearRide();
                  //         Get.find<RideController>()
                  //             .ride
                  //             .value
                  //             .rideRequest
                  //             .status = RideRequestState.SELECTVECHICLE;
                  //       });
                  //       setState(() {});
                  //     },
                  //     text: "get ride",
                  //     boxColor: primaryColorDark,
                  //     shadowColor: primaryColorDark,
                  //     width: width,
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10),
                  //   child: SecondaryButtonWithIcon(
                  //     icon: Icons.online_prediction,
                  //     iconColor: primaryColorWhite,
                  //     onPressed: () async {
                  //       setState(() {
                  //         Get.find<RideController>().clearRide();
                  //         Get.find<RideController>()
                  //             .ride
                  //             .value
                  //             .rideRequest
                  //             .status = RideRequestState.SELECTVECHICLE;
                  //       });
                  //       setState(() {});
                  //     },
                  //     text: "subscribe",
                  //     boxColor: primaryColorDark,
                  //     shadowColor: primaryColorDark,
                  //     width: width,
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10),
                  //   child: SecondaryButtonWithIcon(
                  //     icon: Icons.online_prediction,
                  //     iconColor: primaryColorWhite,
                  //     onPressed: () {
                  //       const message = {
                  //         "senderPhone": "sname",
                  //         "receiverPhone": "rname",
                  //         "location": {"x": 1.2222, "y": 2.444},
                  //       };
                  //       stompClient.send(
                  //         destination: '/app/chat',
                  //         body: json.encode(message),
                  //       );
                  //     },
                  //     text: "send message",
                  //     boxColor: primaryColorDark,
                  //     shadowColor: primaryColorDark,
                  //     width: width,
                  //   ),
                  // ),
                ],
              ),
            ),
            Obx(
              () => mapController.polyLineLoading.value
                  ? Container(
                      color: primaryColorBlack.withOpacity(0.5),
                      child: Center(child: CircularLoading()),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
