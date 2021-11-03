import 'package:flutter/material.dart';
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

class RideController extends GetxController {
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
  }) async {
    try {
      // dynamic response = {
      //   "code": "response.statusCode",
      //   "body": {
      //     "id": "61729901a3a11b360bcbff61",
      //     "passenger": {
      //       "id": "616ffc18b143c65ac1126f4f",
      //       "phone": "+94711737707",
      //       "name": "rathnavibushana",
      //       "rating": 0.0
      //     },
      //     "startLocation": {"x": 0.0, "y": 0.0},
      //     "endLocation": {"x": 10.0, "y": 10.0},
      //     "distance": 10,
      //     "status": "PENDING",
      //     "driver": null,
      //     "organization": null,
      //     "timestamp": 1634900225
      //   },
      //   "error": false,
      // };
      try {
        FirebaseNotifications firebaseNotifications = FirebaseNotifications();
        await firebaseNotifications.startListening();
        await firebaseNotifications.subscribeTopic("addRideRequest");
      } catch (e) {
        Get.snackbar("Something is wrong!!!", "Please try again.");
        return false;
      }
      dynamic response = await request(
        startLocation: startLocation,
        endLocation: endLocation,
        distance: distance,
        token: Get.find<UserController>().passenger.value.token,
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

  Future<bool> rideDetails() async {
    try {
      String id = "61738b977ccb6600387733dc";
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> rideConfirmed({
    required passengerFeedback,
    required driverRating,
  }) async {
    try {
      //hardcoded id
      String id = "61738b977ccb6600387733dc";
      dynamic response = await confirm(
        id: id,
        passengerFeedback: passengerFeedback,
        driverRating: driverRating,
        token: Get.find<UserController>().passenger.value.token,
      );

      if (!response["error"]) {
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
