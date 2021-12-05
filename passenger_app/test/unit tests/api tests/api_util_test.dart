import 'dart:convert';

import 'package:passenger_app/api/passenger_api.dart';
import 'package:passenger_app/api/utils.dart';
import 'package:passenger_app/utils/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

var profileResponseBody = {
  "id": "61820de6fd64760c31213444",
  "phone": "+94763067706",
  "email": "avishkar.18@cse.mrt.ac.lk",
  "name": "Avishka Passenger",
  "totalRating": 4,
  "totalRides": 29,
  "notificationToken":
      "cVsfNcSvSyS-4cBQ6264-W:APA91bHSnQUe_zeU1RHUicyaP20OrhT_dwObeifUS4WgFSRNLRV2T_D5zkewio6oJXRdy4P-F8xb4hKOugH7NRqjjW2VSmmdt-HPg99KJNuor65XXkHJq8MkJIxZv6g8m6S4bg-9Uzvk",
  "status": "ONLINE",
  "enabled": true,
  "suspend": false,
};

const String passengerToken =
    "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIrOTQ3NjMwNjc3MDYiLCJyb2xlcyI6WyJEUklWRVIiXSwidHlwZSI6ImF1dGgiLCJpYXQiOjE2MzU5MTMxOTAsImV4cCI6MTY3MTkxMzE5MH0.lWqkjQ_78RDv2DrIIHIazgou_4fx8ugqKxchTr-3f2Cno7W9SkS5oZbsRIMDq8pmKvOIo70NU77gbrV-WvvTR_W6aNLZON6axjAV6si3KeZYpB6d-FWkfQh-yGcUiWTM0dzsqHCFmHI8gNz7V-KlNyXv5CUfYRRRoTfDK-5tRLTM0ahuO31H9TSp4x7CGCszHCo2LDNzqRDCmB4zn42nqBIdtoUjMMOWjha9oPhlEvGiz80YRyNn5yMixcdLL8xy_Npl2vYv6EyW-AoSg4qCRJAIgHpOFkhsIy5qav5zqpfddkxEkCSJhMguRj5AimKQwkOqTRhiPdDKeDCQFXXhxA";

void main() {
  group(
    "API Utils test: ",
    () {
      group("Get request: ", () {
        test("Success", () async {
          MockClient mockService = MockClient();
          var completeUrl = Uri.http(BASEURL, "/api/passenger/profile");
          when(mockService.get(
            completeUrl,
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $passengerToken',
            },
          )).thenAnswer(
              (_) async => http.Response(jsonEncode(profileResponseBody), 200));
          ApiUtils api = ApiUtils.internal(mockService);
          var out = await api.getRequest(
              url: 'http://ridex.ml/api/passenger/profile',
              token: passengerToken);
          debugPrint(out.toString());
          expect(
            out,
            {
              "code": 200,
              "body": profileResponseBody,
              "error": false,
            },
          );
        });

        test("Fail", () async {
          MockClient mockService = MockClient();
          var completeUrl = Uri.http(BASEURL, "/api/passenger/profile");
          when(mockService.get(
            completeUrl,
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer ',
            },
          )).thenAnswer((_) async => http.Response(
              jsonEncode({
                "message": "Forbidden",
              }),
              403));
          ApiUtils api = ApiUtils.internal(mockService);
          var out = await api.getRequest(
              url: 'http://ridex.ml/api/passenger/profile', token: '');
          debugPrint(out.toString());
          expect(
            out,
            {
              "code": 403,
              "body": {
                "message": "Forbidden",
              },
              "error": true,
            },
          );
        });
      });
    },
  );
}
