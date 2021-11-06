import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:passenger_app/api/utils.dart';
import 'package:passenger_app/utils/config.dart';

class MapController extends GetxController {
  Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = "";
    String url =
        "/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Google_MAP_API_KEY}";
    String st1 = "";
    String st2 = "";
    String st3 = "";
    String st4 = "";
    var response = await externalAPIGetRequest(url: url);
    if (response != "error") {
      //debugPrint(
      //  "sdvds: " + response["results"][0]["formatted_address"].toString());
      placeAddress = response["results"][0]["formatted_address"];
      // st1 = response["results"][0]["address_components"][1]["long_name"];
      // st2 = response["results"][0]["address_components"][2]["long_name"];
      debugPrint(st1 + ", " + st2);
    }
    return placeAddress;
  }
}
