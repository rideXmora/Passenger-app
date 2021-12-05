import 'dart:io';

import 'package:passenger_app/controllers/ride_controller.dart';
import 'package:passenger_app/controllers/user_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:passenger_app/utils/ride_state_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotifications {
  late FirebaseMessaging _messaging;

  Future<void> setupFirebase() async {
    _messaging = FirebaseMessaging.instance;
    await firebaseCloudMessageListner();
  }

  Future<void> firebaseCloudMessageListner() async {
    // check if app is opened with message
    await FirebaseMessaging.instance.getInitialMessage();

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  //TODO
  Future<String> getToken() async {
    var token = await _messaging.getToken();

    print('My token 1: $token ');
    return token.toString();
  }

  Future<void> startListening() async {
    await FirebaseMessaging.instance.getInitialMessage();
    debugPrint("start listning");
// listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("new foreground message");
      if (message.notification != null) {
        debugPrint(message.notification!.title);
        debugPrint(message.notification!.body);
        debugPrint(message.data.toString());
        debugPrint("id: " + message.data['id']);
        String id = "";
        if (message.notification!.title == null) {
          Get.snackbar("Something is wrong!!!", "Please try again.");
        } else {
          String state = message.notification!.title!;
          debugPrint(getRideState(state).toString());
          if (message.data['id'] != null) {
            id = message.data['id'];

            if (getRideState(state) == RideState.ACCEPTED) {
              await Get.find<RideController>().rideDetails(id);
            } else {
              await Get.find<RideController>().changeRideState(state);
            }
          } else {
            debugPrint("error");
            Get.snackbar("Something is wrong!!!", "Please try again.");
          }
        }
      } else {
        Get.snackbar("Something is wrong!!!", "Please try again.");
      }
    });

    // listen to os notification clicks
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint("new background message");
      if (message.notification != null) {
        debugPrint(message.notification!.title);
        debugPrint(message.notification!.body);
        debugPrint(message.data.toString());
        debugPrint("id: " + message.data['id']);
        String id = "";
        if (message.notification!.title == null) {
          Get.snackbar("Something is wrong!!!", "Please try again.");
        } else {
          String state = message.notification!.title!;
          debugPrint(getRideState(state).toString());
          if (message.data['id'] != null) {
            id = message.data['id'];
            if (getRideState(state) == RideState.ACCEPTED) {
              await Get.find<RideController>().rideDetails(id);
            } else {
              await Get.find<RideController>().changeRideState(state);
            }
          } else {
            debugPrint("error");
            Get.snackbar("Something is wrong!!!", "Please try again.");
          }
        }
      } else {
        Get.snackbar("Something is wrong!!!", "Please try again.");
      }
    });
  }

  Future<void> subscribeTopic(String topic) async {
    _messaging = FirebaseMessaging.instance;
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unSubscribeTopic(String topic) async {
    _messaging = FirebaseMessaging.instance;
    await _messaging.unsubscribeFromTopic(topic);
  }
}
