import 'package:passenger_app/api/utils.dart';
import 'package:passenger_app/modals/location.dart';

Future<dynamic> request(
    {required Location startLocation,
    required Location endLocation,
    required double distance,
    required String token}) async {
  String url = '/api/passenger/ride/request';
  dynamic response = await postRequest(
    url: url,
    data: {
      "startLocation": startLocation.toJson(),
      "endLocation": endLocation.toJson(),
      "distance": distance,
    },
    token: token,
  );
  return response;
}

Future<dynamic> getRide({required String id, required String token}) async {
  String url = '/api/passenger/ride/getRide';
  dynamic response = await postRequest(
    url: url,
    data: {
      "id": id,
    },
    token: token,
  );
  return response;
}

Future<dynamic> confirm(
    {required String id,
    required String passengerFeedback,
    required int driverRating,
    required String token}) async {
  String url = '/api/passenger/ride/confirm';
  dynamic response = await postRequest(
    url: url,
    data: {
      "id": id,
      "passengerFeedback": passengerFeedback,
      "driverRating": driverRating
    },
    token: token,
  );
  return response;
}

Future<dynamic> cancel({required String id, required String token}) async {
  String url = '/api/passenger/ride/request/timeout';
  dynamic response = await postRequest(
    url: url,
    data: {
      "id": id,
    },
    token: token,
  );
  return response;
}
