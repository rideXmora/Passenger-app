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
  }) async {
    try {
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
  }) async {
    try {
      //hardcoded id
      String id = ride.value.id;
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
