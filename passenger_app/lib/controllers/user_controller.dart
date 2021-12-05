import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passenger_app/api/passenger_api.dart';
import 'package:passenger_app/api/utils.dart';
import 'package:passenger_app/controllers/map_controller.dart';
import 'package:passenger_app/modals/location.dart';
import 'package:passenger_app/modals/passenger.dart';
import 'package:passenger_app/modals/past_trip.dart';
import 'package:passenger_app/pages/bottom_navigation_bar_handler.dart';
import 'package:passenger_app/utils/language.dart';
import 'package:passenger_app/utils/payment_method.dart';
import 'package:passenger_app/utils/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class UserController extends GetxController {
  late final PassengerApi passengerApi;

  UserController(this.passengerApi);

  void initState() {
    this.passengerApi = PassengerApi(ApiUtils());
  }

  @visibleForTesting
  UserController.internal(this.passengerApi);

  var pastTrips = [].obs;
  var passenger = Passenger(
    id: "",
    email: "",
    enabled: false,
    name: "",
    pastRides: [],
    phone: "",
    refreshToken: "",
    suspend: false,
    token: "",
    totalRating: 0,
    totalRides: 0,
    notificationToken: "",
  ).obs;

  void clearData() {
    passenger.update((val) {
      val!.id = "";
      val.email = "";
      val.enabled = false;
      val.name = "";
      val.pastRides = [];
      val.phone = "";
      val.refreshToken = "";
      val.suspend = false;
      val.token = "";
      val.totalRating = 0;
      val.totalRides = 0;
      val.notificationToken = "";
    });
  }

  void signOutUser() {
    clearData();
  }

  void savePassengerData(dynamic data) {
    passenger.update((val) {
      val!.id = data["id"];
      val.phone = data["phone"];
      val.email = data["email"] == null ? "" : data["email"];
      val.name = data["name"] == null ? "" : data["name"];
      val.totalRating = data["totalRating"];
      val.totalRides = data["totalRides"];
      val.pastRides =
          data["pastRides"] == null ? [] : List<String>.from(data["pastRides"]);
      val.token = data["token"];
      val.refreshToken = data["refreshToken"];
      val.enabled = data["enabled"] == null ? false : data["enabled"];
      val.suspend = data["suspend"] == null ? false : data["suspend"];
      val.notificationToken =
          data["notificationToken"] == null ? "" : data["notificationToken"];
    });
  }

//change
  void updatePassengerData(
    dynamic data,
    String token,
    String refreshToken,
  ) {
    passenger.update((val) {
      val!.id = data["id"];
      val.phone = data["phone"];
      val.email = data["email"] == null ? "" : data["email"];
      val.name = data["name"] == null ? "" : data["name"];
      val.totalRating = data["totalRating"];
      val.totalRides = data["totalRides"];
      val.pastRides =
          data["pastRides"] == null ? [] : List<String>.from(data["pastRides"]);
      val.token = token;
      val.refreshToken = refreshToken;
      val.enabled = data["enabled"] == null ? false : data["enabled"];
      val.suspend = data["suspend"] == null ? false : data["suspend"];
      val.notificationToken =
          data["notificationToken"] == null ? "" : data["notificationToken"];
    });
  }

  void updatePassengerProfileData(
    dynamic data,
  ) {
    passenger.update((val) {
      val!.email = data["email"] == null ? "" : data["email"];
      val.name = data["name"] == null ? "" : data["name"];
    });
  }

  // submit otp from MobileNumberVerification
  Future<bool> changeProfile(
      {required String name,
      required String email,
      required String language}) async {
    if (name.length == 0) {
      Get.snackbar("Name is not valid!!!", "Name field cannot be empty");
      return false;
    } else if (!isEmailValid(email)) {
      return false;
    } else {
      dynamic response = await passengerApi.profileUpdate(
          name: name,
          email: email,
          notificationToken:
              Get.find<UserController>().passenger.value.notificationToken,
          token: Get.find<UserController>().passenger.value.token);
      debugPrint(response["enabled"].toString());

      if (!response["error"]) {
        if (response["body"]["enabled"]) {
          SharedPreferences store = await SharedPreferences.getInstance();
          Get.find<UserController>().updatePassengerProfileData(
            response["body"],
          );
          var locale = Locale(LanguageUtils.getLocale(language).split("_")[0],
              LanguageUtils.getLocale(language).split("_")[1]);
          store.setString(
            "lan",
            LanguageUtils.getLocale(language),
          );
          Get.updateLocale(locale);
          debugPrint(
              Get.find<UserController>().passenger.value.toJson().toString());
          return true;
        } else {
          Get.snackbar("Something is wrong!!!", "Please try again");
          return false;
        }
      }
    }
    return false;
  }

  void updateNotificationToken(String token) {
    passenger.value.notificationToken = token;
  }

  Future<void> getPastTripDetails() async {
    dynamic response = await passengerApi.past(
        token: Get.find<UserController>().passenger.value.token);

    debugPrint(response["enabled"].toString());

    if (!response["error"]) {
      pastTrips.clear();
      for (var i = 0; i < response["body"].length; i++) {
        Location startLocation = Location(
            x: response["body"][i]["rideRequest"]["startLocation"]["x"],
            y: response["body"][i]["rideRequest"]["startLocation"]["y"]);
        Location endLocation = Location(
            x: response["body"][i]["rideRequest"]["endLocation"]["x"],
            y: response["body"][i]["rideRequest"]["endLocation"]["y"]);

        String startLocationText =
            await Get.find<MapController>().searchAddress(startLocation);
        String endLocationText =
            await Get.find<MapController>().searchAddress(endLocation);
        int distance = response["body"][i]["rideRequest"]["distance"];
        double payment = response["body"][i]["payment"];
        PaymentMethod paymentMethod = PaymentMethod.CASH;
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(
            response["body"][i]["rideRequest"]["timestamp"] * 1000);

        String dateString = date.year.toString() +
            " " +
            DateFormat('MMMM').format(DateTime(0, date.month)) +
            " " +
            date.day.toString();
        PastTrip pastTrip = PastTrip(
          startLocation: startLocation,
          endLocation: endLocation,
          startLocationText: startLocationText,
          endLocationText: endLocationText,
          distance: distance,
          payment: payment,
          paymentMethod: PaymentMethod.CASH,
          date: dateString,
        );
        pastTrips.add(pastTrip);
      }

      pastTrips.refresh();
    }
  }
}
