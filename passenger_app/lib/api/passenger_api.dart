import 'package:flutter/material.dart';
import 'package:passenger_app/api/utils.dart';

class PassengerApi {
  late final ApiUtils apiUtils;
  PassengerApi(this.apiUtils);

  void initState() {
    this.apiUtils = ApiUtils();
  }

  @visibleForTesting
  PassengerApi.internal(this.apiUtils);

  Future<dynamic> profile({required String token}) async {
    String url = '/api/passenger/profile';
    dynamic response = await apiUtils.getRequest(
      url: url,
      token: token,
    );
    return response;
  }

  Future<dynamic> profileUpdate({
    required String name,
    required String email,
    required String token,
    required String notificationToken,
  }) async {
    String url = '/api/passenger/profileUpdate';
    dynamic response = await apiUtils.putRequest(
      url: url,
      data: {
        "email": email,
        "name": name,
        "notificationToken": notificationToken,
      },
      token: token,
    );
    return response;
  }

  Future<dynamic> past({required String token}) async {
    String url = '/api/passenger/ride/past';
    dynamic response = await apiUtils.getRequest(
      url: url,
      token: token,
    );
    return response;
  }
}
