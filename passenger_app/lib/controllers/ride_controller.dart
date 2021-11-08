import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:passenger_app/api/passenger_ride_api.dart';
import 'package:passenger_app/controllers/user_controller.dart';
import 'package:passenger_app/modals/location.dart';
import 'package:passenger_app/modals/organization.dart';
import 'package:passenger_app/modals/ride.dart';
import 'package:passenger_app/modals/ride_request_driver.dart';
import 'package:passenger_app/modals/ride_request_passenger.dart';
import 'package:passenger_app/modals/ride_request_res.dart';
import 'package:passenger_app/modals/ride_request_vehicle.dart';
import 'package:passenger_app/utils/firebase_notification_handler.dart';
import 'package:passenger_app/utils/ride_request_state_enum.dart';
import 'package:passenger_app/utils/ride_state_enum.dart';
import 'package:passenger_app/utils/vehicle_type.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class RideController extends GetxController {
  Rx<VehicleType> vehicleType = VehicleType.CAR.obs;
  var stompClient;
  var ride = Ride(
    rideRequest: RideRequestRes(
      passenger: RideRequestPassenger(),
      startLocation: Location(
        x: 0,
        y: 0,
      ),
      endLocation: Location(
        x: 0,
        y: 0,
      ),
      driver: RideRequestDriver(
        vehicle: RideRequestVehicle(),
      ),
      organization: Organization(),
      timestamp: DateTime.now(),
    ),
  ).obs;

  void clearRide() {
    ride.value = Ride(
      id: "",
      rideStatus: RideState.NOTRIP,
      rideRequest: RideRequestRes(
        status: RideRequestState.NOTRIP,
        passenger: RideRequestPassenger(),
        startLocation: Location(
          x: 0,
          y: 0,
        ),
        endLocation: Location(
          x: 0,
          y: 0,
        ),
        driver: RideRequestDriver(
          vehicle: RideRequestVehicle(),
        ),
        organization: Organization(),
        timestamp: DateTime.now(),
      ),
    );
  }

  void updateRideRequest(dynamic response) {
    RideRequestRes rideRequestRes = RideRequestRes.fromJson(response);
    ride.update((val) {
      val!.rideRequest = rideRequestRes;
    });
  }

  void updateRide(dynamic response) {
    RideRequestRes rideRequestRes =
        RideRequestRes.fromJson(response["rideRequest"]);
    ride.update((val) {
      val!.id = response["id"];
      val.rideRequest = rideRequestRes;
      val.payment = response["payment"] == null ? 0 : response["payment"];
      val.rideStatus = getRideState(response["rideStatus"]);
    });
  }

  Future<bool> rideRequestSending({
    required Location startLocation,
    required Location endLocation,
    required double distance,
    required VehicleType vehicleType,
  }) async {
    try {
      debugPrint(startLocation.toJson().toString());
      debugPrint(endLocation.toJson().toString());
      debugPrint(getDriverVehicleTypeString(vehicleType));
      dynamic response = await request(
        startLocation: startLocation,
        endLocation: endLocation,
        distance: distance,
        token: Get.find<UserController>().passenger.value.token,
        vehicleType: getDriverVehicleTypeString(vehicleType),
      );

      if (!response["error"]) {
        updateRideRequest(
          response["body"],
        );
        debugPrint("ride : " + ride.value.toJson().toString());

        debugPrint(
            "ride - request : " + ride.value.rideRequest.toJson().toString());
        if (getRideRequestState(response["body"]["status"]) ==
            RideRequestState.PENDING) {
          return true;
        } else {
          Get.snackbar("Something is wrong!!!", "Please try again.");
          return false;
        }
      } else {
        Get.snackbar("Something is wrong!!!", "Please try again.");
        return false;
      }
    } catch (e) {
      Get.snackbar("Something is wrong!!!", "Please try again.");
      return false;
    }
  }

  Future<bool> rideCancel() async {
    try {
      //hardcoded id
      String id = ride.value.rideRequest.id;
      dynamic response = await cancel(
        id: id,
        token: Get.find<UserController>().passenger.value.token,
      );

      if (!response["error"]) {
        clearRide();

        debugPrint("ride : " + ride.value.toJson().toString());

        debugPrint(
            "ride - request : " + ride.value.rideRequest.toJson().toString());

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // void onConnect(StompFrame frame) {
  //   var sname = Get.find<RideController>().ride.value.rideRequest.driver.phone;
  //   debugPrint(sname);
  //   stompClient.subscribe(
  //     destination: "/user/" + sname + "/queue/messages",
  //     callback: (frame) {
  //       var result = json.decode(frame.body!);
  //       print("passenger: " + result);
  //     },
  //   );

  //   // Timer.periodic(Duration(seconds: 10), (_) {
  //   //   const message = {
  //   //     "senderPhone": "sname",
  //   //     "receiverPhone": "rname",
  //   //     "location": {"x": 1.2222, "y": 2.444},
  //   //   };
  //   //   stompClient.send(
  //   //     destination: '/app/chat',
  //   //     body: json.encode(message),
  //   //   );
  //   // });
  // }

  Future<bool> rideDetails(String id) async {
    try {
      dynamic response = await getRide(
        id: id,
        token: Get.find<UserController>().passenger.value.token,
      );

      if (!response["error"]) {
        updateRide(
          response["body"],
        );
        debugPrint("ride : " + ride.value.toJson().toString());

        debugPrint(
            "ride - request : " + ride.value.rideRequest.toJson().toString());
        // try {
        //   stompClient = StompClient(
        //       config: StompConfig.SockJS(
        //     url: 'http://ridex.ml/ws',
        //     onConnect: onConnect,
        //     beforeConnect: () async {
        //       print('waiting to connect...');
        //       await Future.delayed(Duration(milliseconds: 200));
        //       print('connecting...');
        //     },
        //     onWebSocketError: (dynamic error) => print(error.toString()),
        //     // stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
        //     // webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
        //   ));
        //   stompClient.activate();

        //   // Timer.periodic(Duration(seconds: 2), (Timer timer) async {
        //   //   debugPrint("safa");
        //   //   Position position = await Geolocator.getCurrentPosition(
        //   //       desiredAccuracy: LocationAccuracy.high);

        //   //   var message = {
        //   //     "senderPhone": Get.find<UserController>().driver.value.phone,
        //   //     "receiverPhone": Get.find<RideController>()
        //   //         .ride
        //   //         .value
        //   //         .rideRequest
        //   //         .passenger
        //   //         .phone,
        //   //     "location": {"x": position.latitude, "y": position.longitude},
        //   //   };
        //   //   stompClient.send(
        //   //     destination: '/app/chat',
        //   //     body: json.encode(message),
        //   //   );
        //   //   if (Get.find<RideController>().ride.value.rideStatus ==
        //   //           RideState.DROPPED ||
        //   //       Get.find<RideController>().ride.value.rideStatus ==
        //   //           RideState.FINISHED ||
        //   //       Get.find<RideController>().ride.value.rideStatus ==
        //   //           RideState.NOTRIP) {
        //   //     timer.cancel();
        //   //   }
        //   // });
        // } catch (e) {
        //   debugPrint(e.toString());
        // }
        // stompClient.activate();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> changeRideState(String state) async {
    try {
      RideState rideState = getRideState(state);
      if (rideState == RideState.ACCEPTED) {
        ride.value.rideStatus = RideState.ACCEPTED;
      } else if (rideState == RideState.ARRIVED) {
        ride.update((val) {
          val!.rideStatus = RideState.ARRIVED;
        });
      } else if (rideState == RideState.PICKED) {
        ride.update((val) {
          val!.rideStatus = RideState.PICKED;
        });
      } else if (rideState == RideState.DROPPED) {
        ride.update((val) {
          val!.rideStatus = RideState.DROPPED;
        });
      } else if (rideState == RideState.FINISHED) {
        ride.update((val) {
          val!.rideStatus = RideState.FINISHED;
        });
      } else if (rideState == RideState.PASSENGERRATEANDCOMMENT) {
        ride.update((val) {
          val!.rideStatus = RideState.PASSENGERRATEANDCOMMENT;
        });
      } else if (rideState == RideState.CONFIRMED) {
        ride.update((val) {
          val!.rideStatus = RideState.CONFIRMED;
        });
      } else if (rideState == RideState.NOTRIP) {
        ride.update((val) {
          val!.rideStatus = RideState.NOTRIP;
        });
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> rideComplete() async {
    try {
      ride.value.rideStatus = RideState.PASSENGERRATEANDCOMMENT;
      return true;
    } catch (e) {
      return true;
    }
  }

  Future<bool> rideConfirmed({
    required passengerFeedback,
    required driverRating,
    required complain,
  }) async {
    try {
      //hardcoded id
      String id = ride.value.id;
      debugPrint("complain " + complain.toString());
      dynamic response = await confirm(
        id: id,
        passengerFeedback: passengerFeedback,
        driverRating: driverRating,
        token: Get.find<UserController>().passenger.value.token,
      );
      debugPrint("complain " + complain.toString());
      if (!response["error"]) {
        debugPrint("complain " + complain.toString());
        if (complain) {
          dynamic response2 = await complain(
            id: id,
            complain: passengerFeedback,
            token: Get.find<UserController>().passenger.value.token,
          );
          debugPrint("Complain response: " + response2["body"]);
        }
        updateRide(
          response["body"],
        );
        debugPrint("ride : " + ride.value.toJson().toString());

        debugPrint(
            "ride - request : " + ride.value.rideRequest.toJson().toString());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
