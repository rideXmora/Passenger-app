import 'package:passenger_app/api/utils.dart';

Future<dynamic> phoneAuth({required String phone}) async {
  String url = '/api/auth/passenger/phoneAuth';
  dynamic response = await postRequest(
    url: url,
    data: {
      "phone": phone,
    },
  );
  return response;
}

Future<dynamic> phoneVerify(
    {required String phone, required String otp}) async {
  String url = '/api/auth/passenger/phoneVerify';
  dynamic response = await postRequest(
    url: url,
    data: {
      "phone": phone,
      "otp": otp,
    },
  );
  return response;
}
