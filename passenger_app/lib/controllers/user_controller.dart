import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:passenger_app/api/passenger_api.dart';
import 'package:passenger_app/modals/passenger.dart';
import 'package:passenger_app/pages/bottom_navigation_bar_handler.dart';
import 'package:passenger_app/utils/language.dart';
import 'package:passenger_app/utils/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
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
    });
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

  void signOutUser() {
    clearData();
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
      dynamic response = await profileUpdate(
          name: name,
          email: email,
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
}
