import 'package:flutter/material.dart';
import 'package:passenger_app/api/utils.dart';

class AuthApi {
  late final ApiUtils apiUtils;
  AuthApi(this.apiUtils);

  void initState() {
    this.apiUtils = ApiUtils();
  }

  @visibleForTesting
  AuthApi.internal(this.apiUtils);
  Future<dynamic> phoneAuth({required String phone}) async {
    String url = '/api/auth/passenger/phoneAuth';
    dynamic response = await apiUtils.postRequest(
      url: url,
      data: {
        "phone": phone,
      },
      token: '',
    );
    return response;
  }

  Future<dynamic> phoneVerify(
      {required String phone, required String otp}) async {
    String url = '/api/auth/passenger/phoneVerify';
    dynamic response = await apiUtils.postRequest(
      url: url,
      data: {
        "phone": phone,
        "otp": otp,
      },
      token: '',
    );
    return response;
  }

  Future<dynamic> profileComplete({
    required String name,
    required String email,
    required String token,
    required String notificationToken,
  }) async {
    String url = '/api/passenger/profileComplete';
    dynamic response = await apiUtils.postRequest(
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
}
