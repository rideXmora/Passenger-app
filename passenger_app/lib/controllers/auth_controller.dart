import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:passenger_app/api/auth_api.dart';
import 'package:passenger_app/controllers/user_controller.dart';
import 'package:passenger_app/pages/bottom_navigation_bar_handler.dart';
import 'package:passenger_app/pages/sign_in_up/pages/getting_started_screen.dart';
import 'package:passenger_app/pages/sign_in_up/pages/language_selection_screen.dart';
import 'package:passenger_app/pages/sign_in_up/pages/mobile_number_verification_screen.dart';
import 'package:passenger_app/pages/sign_in_up/pages/registration_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var languageSelection = 1.obs;
  // SplashScreen data loading
  Future<void> loadData() async {
    await checkLangugae();
  }

  // requesting otp from GettingStartedScreen
  Future<void> getOTP({required String phone, required String from}) async {
    if (phone.length == 12) {
      dynamic response = await phoneAuth(phone: phone);
      if (response["error"] != true) {
        if (from == "main") {
          Get.to(() => MobileNumberVerificationScreen(phoneNo: phone));
        } else {
          Get.snackbar(
              "OTP re-sent to ($phone) number!!!", "Please check your inbox");
        }
      }
    } else {
      Get.snackbar("Phone number is not valid!!!",
          "Phone number must have 9 characters");
    }
  }

  // submit otp from MobileNumberVerification
  Future<void> submitOTP({required String phone, required String otp}) async {
    debugPrint(otp.toString());
    if (phone.length < 12) {
      Get.snackbar("Phone number is not valid!!!",
          "Phone number must have 9 characters");
    } else if (otp.length < 6) {
      Get.snackbar("OTP is not valid!!!", "Otp must have 6 characters");
    } else {
      dynamic response = await phoneVerify(phone: phone, otp: otp);
      debugPrint(response["enabled"].toString());

      if (!response["error"]) {
        if (response["body"]["enabled"]) {
          Get.find<UserController>().savePassengerData(response["body"]);
          debugPrint(Get.find<UserController>().passenger.value.toString());
          Get.offAll(() => BottomNavHandler());
        } else {
          Get.find<UserController>().savePassengerData(response["body"]);
          debugPrint(Get.find<UserController>().passenger.value.toString());
          Get.to(() => RegistrationScreen(phoneNo: phone));
        }
      }
      return;
    }
  }

  //check language on app loading
  Future<void> checkLangugae() async {
    SharedPreferences store = await SharedPreferences.getInstance();

    if (store.get("lan") == null) {
      Get.to(() => LanguageSelectionScreen());
      return;
    }
  }

  //add language to local storage
  Future<void> addLangugae(String language) async {
    SharedPreferences store = await SharedPreferences.getInstance();

    store.setString("lan", language);
    Get.to(GettingStartedScreen());
  }
}
