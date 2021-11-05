import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:passenger_app/utils/firebase_notification_handler.dart';
import 'package:passenger_app/utils/ride_request_state_enum.dart';
import 'package:passenger_app/utils/ride_state_enum.dart';
import 'package:passenger_app/theme/colors.dart';
import 'package:passenger_app/widgets/secondary_button_with_icon.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:sockjs_client_wrapper/sockjs_client_wrapper.dart';
// import "package:stomp/stomp.dart";
// import "package:stomp/vm.dart" show connect;
// import 'dart:convert';

// import 'package:stomp_dart_client/stomp.dart';
// import 'package:stomp_dart_client/stomp_config.dart';
// import 'package:stomp_dart_client/stomp_frame.dart';

import 'package:geolocator/geolocator.dart';

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

  // RideState rideState = RideState.NOTRIP;
  // RideRequestState rideRequest = RideRequestState.NOTRIP;

  int rating = 1;
  TextEditingController comment = TextEditingController();

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  late GoogleMapController newGoogleMapController;

  late Position currentPosition;

  Future<void> locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLastPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLastPosition, zoom: 14);

    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      paymentMethod.text = methods[0]["method"];
      slectedMethod = 0;
    });
    // loadSocket();
  }

  // void loadSocket() {
  //   // final echoUri = Uri.parse('http://localhost:8080/ws');
  //   // final options = SockJSOptions(
  //   //     transports: ['websocket', 'xhr-streaming', 'xhr-polling']);
  //   // final socket = SockJSClient(echoUri, options: options);

  //   // connect("foo.server.com").then((StompClient client) {
  //   //   client.subscribeString("/foo",
  //   //       (Map<String, String> headers, String message) {
  //   //     print("Recieve $message");
  //   //   },socket);

  //   //   client.sendString("/foo", "Hi, Stomp");
  //   // });
  //   stompClient = StompClient(
  //     config: StompConfig(
  //       url: 'http://localhost:8080/ws',
  //       onConnect: onConnect,
  //       beforeConnect: () async {
  //         print('waiting to connect...');
  //         await Future.delayed(Duration(milliseconds: 200));
  //         print('connecting...');
  //       },
  //       onWebSocketError: (dynamic error) => print(error.toString()),
  //       stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
  //       webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
  //     ),
  //   );
  // }

  // void onConnect(StompFrame frame) {
  //   stompClient.subscribe(
  //     destination: '/ride/request',
  //     callback: (frame) {
  //       List<dynamic>? result = json.decode(frame.body!);
  //       print(result);
  //     },
  //   );

  //   Timer.periodic(Duration(seconds: 10), (_) {
  //     stompClient.send(
  //       destination: '/app/request',
  //       body: json.encode({'a': 123}),
  //     );
  //   });
  // }

  // late final stompClient;

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
    }
  }

  void acceptedOnPressedToCall() async {
    if (!loadingGreen) {
      setState(() {
        loadingGreen = true;
      });
      // real action is to call driver
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
      // real action is to call driver
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
      );

      setState(() {
        loadingGreen = false;
        comment.text = "";
        rating = 1;
      });
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
      );

      setState(() {
        loadingRed = false;
      });
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
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controllerGoogleMap.complete(controller);
                      newGoogleMapController = controller;

                      locatePosition();
                    },
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
                                      time: "1 min",
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
                                          time: "1 min",
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
                        )
                      : Container(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SecondaryButtonWithIcon(
                      icon: Icons.online_prediction,
                      iconColor: primaryColorWhite,
                      onPressed: () async {
                        setState(() {
                          Get.find<RideController>().clearRide();
                          Get.find<RideController>()
                              .ride
                              .value
                              .rideRequest
                              .status = RideRequestState.SELECTVECHICLE;
                        });
                        setState(() {});
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
