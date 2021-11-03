import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:passenger_app/api/auth_api.dart';
import 'package:passenger_app/api/passenger_api.dart';
import 'package:passenger_app/controllers/user_controller.dart';
import 'package:passenger_app/pages/bottom_navigation_bar_handler.dart';
import 'package:passenger_app/pages/sign_in_up/pages/getting_started_screen.dart';
import 'package:passenger_app/pages/sign_in_up/pages/language_selection_screen.dart';
import 'package:passenger_app/pages/sign_in_up/pages/mobile_number_verification_screen.dart';
import 'package:passenger_app/pages/sign_in_up/pages/registration_screen.dart';
import 'package:passenger_app/utils/firebase_notification_handler.dart';
import 'package:passenger_app/utils/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var languageSelection = 1.obs;
  // SplashScreen data loading
  Future<void> loadData() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    SharedPreferences store = await SharedPreferences.getInstance();
    String token = store.getString("token") == null
        ? ''
        : store.getString("token").toString();
    String refreshToken = store.getString("refreshToken") == null
        ? ''
        : store.getString("refreshToken").toString();
    String lan =
        store.getString("lan") == null ? '' : store.getString("lan").toString();
    debugPrint("token : \n" +
        token +
        "\n refreshToken : \n" +
        refreshToken +
        "\n lan : \n" +
        lan);
    try {
      if (lan == '') {
        debugPrint("Language null");
        store.remove("token");
        store.remove("refreshToken");
        Get.offAll(LanguageSelectionScreen());
      } else {
        debugPrint("Language not null");
        var locale = Locale(lan.split("_")[0], lan.split("_")[1]);
        Get.updateLocale(locale);
        if (token == '') {
          debugPrint("token null");
          Get.offAll(GettingStartedScreen());
        } else {
          debugPrint("token not null");
          try {
            FirebaseNotifications firebaseNotifications =
                FirebaseNotifications();
            await firebaseNotifications.setupFirebase();
          } catch (e) {
            debugPrint("firebase notification error");
            Get.offAll(GettingStartedScreen());
          }
          bool isExpired = await isTokenExpired();
          if (isExpired) {
            debugPrint("token expired refresh need");
            //to do
            //regenerate token with refresh token
            Get.offAll(GettingStartedScreen());
          } else {
            debugPrint("token valid");
            dynamic response = await profile(token: token);
            Get.find<UserController>().clearData();
            //change
            Get.find<UserController>().updatePassengerData(
              response["body"],
              token,
              refreshToken,
            );
            debugPrint(
                Get.find<UserController>().passenger.value.toJson().toString());
            Get.offAll(() => BottomNavHandler());
          }
        }
      }
    } catch (e) {
      Get.offAll(GettingStartedScreen());
    }
  }

  Future<bool> isTokenExpired() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    bool hasExpired = JwtDecoder.isExpired(store.getString("token").toString());

    return hasExpired;
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
    SharedPreferences store = await SharedPreferences.getInstance();
    debugPrint(otp.toString());

    if (otp.length < 6) {
      Get.snackbar("OTP is not valid!!!", "Otp must have 6 characters");
    } else {
      try {
        FirebaseNotifications firebaseNotifications = FirebaseNotifications();
        await firebaseNotifications.setupFirebase();
      } catch (e) {
        debugPrint("firebase notification error");
        return;
      }
      dynamic response = await phoneVerify(phone: phone, otp: otp);
      if (!response["error"]) {
        String token = response["body"]["token"];
        String refreshToken = response["body"]["refreshToken"];
        store.setString(
          "token",
          token,
        );
        store.setString(
          "refreshToken",
          refreshToken,
        );
        Get.find<UserController>().clearData();
        if (response["body"]["enabled"]) {
          Get.find<UserController>().savePassengerData(response["body"]);
          debugPrint("passenger object\n" +
              Get.find<UserController>().passenger.value.toJson().toString());
          Get.offAll(() => BottomNavHandler());
        } else {
          Get.find<UserController>().savePassengerData(response["body"]);
          debugPrint("passenger object\n" +
              Get.find<UserController>().passenger.value.toJson().toString());
          Get.to(() => RegistrationScreen(phoneNo: phone));
        }
      }

      return;
    }
  }

  // submit otp from MobileNumberVerification
  Future<void> register({required String name, required String email}) async {
    if (name.length == 0) {
      Get.snackbar("Name is not valid!!!", "Name field cannot be empty");
    } else if (!isEmailValid(email)) {
    } else {
      String notificationToken = "";
      try {
        FirebaseNotifications firebaseNotifications = FirebaseNotifications();
        await firebaseNotifications.setupFirebase();
        notificationToken = await firebaseNotifications.getToken();
      } catch (e) {
        Get.snackbar("Something is wrong!!!", "Please try again");
        return;
      }
      dynamic response = await profileComplete(
        name: name,
        email: email,
        notificationToken: notificationToken,
        token: Get.find<UserController>().passenger.value.token,
      );

      if (!response["error"]) {
        if (response["body"]["enabled"]) {
          SharedPreferences store = await SharedPreferences.getInstance();
          String token = store.getString("token").toString();
          String refreshToken = store.getString("refreshToken").toString();
          Get.find<UserController>().updatePassengerData(
            response["body"],
            token,
            refreshToken,
          );
          debugPrint(
              Get.find<UserController>().passenger.value.toJson().toString());
          Get.offAll(() => BottomNavHandler());
        } else {
          Get.snackbar("Something is wrong!!!", "Please try again");
        }
      }
      return;
    }
  }

  // sign out user from the application
  Future<void> signOut() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    store.remove("token");
    store.remove("refreshToken");
    Get.find<UserController>().signOutUser();
    Get.offAll(GettingStartedScreen());
  }
}
