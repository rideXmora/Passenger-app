import 'package:passenger_app/api/utils.dart';

Future<dynamic> profile({required String token}) async {
  String url = '/api/passenger/profile';
  dynamic response = await getRequest(
    url: url,
    token: token,
  );
  return response;
}

Future<dynamic> profileUpdate(
    {required String name,
    required String email,
    required String token}) async {
  String url = '/api/passenger/profileUpdate';
  dynamic response = await putRequest(
    url: url,
    data: {
      "email": email,
      "name": name,
    },
    token: token,
  );
  return response;
}
