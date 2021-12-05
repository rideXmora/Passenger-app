import 'dart:convert';

import 'package:passenger_app/api/auth_api.dart';
import 'package:passenger_app/api/utils.dart';
import 'package:passenger_app/utils/vehicle_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements ApiUtils {
  Future<Map<dynamic, dynamic>> postRequest(
      {required String url,
      required Map<String, dynamic> data,
      required String token}) async {
    var dataString = data.toString();
    if (url == '/api/auth/passenger/phoneAuth') {
      if (dataString == {"phone": "+94711737706"}.toString()) {
        var body = {
          "message": "Otp sent",
        };
        return {
          "code": 200,
          "body": body,
          "error": false,
        };
      } else {
        var body = {
          "message": "Unable to generate OTP",
        };
        return {
          "code": 500,
          "body": body,
          "error": true,
        };
      }
    } else if (url == '/api/auth/passenger/phoneVerify') {
      if (dataString == {"phone": "+94763067706", "otp": "123456"}.toString()) {
        var body = {
          "id": "61820de6fd64760c31213444",
          "phone": "+94763067706",
          "email": null,
          "name": null,
          "totalRating": 0,
          "totalRides": 0,
          "pastRides": null,
          "token":
              "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIrOTQ3NjMwNjc3MDYiLCJyb2xlcyI6WyJEUklWRVIiXSwidHlwZSI6ImF1dGgiLCJpYXQiOjE2MzU5MTMxOTAsImV4cCI6MTY3MTkxMzE5MH0.lWqkjQ_78RDv2DrIIHIazgou_4fx8ugqKxchTr-3f2Cno7W9SkS5oZbsRIMDq8pmKvOIo70NU77gbrV-WvvTR_W6aNLZON6axjAV6si3KeZYpB6d-FWkfQh-yGcUiWTM0dzsqHCFmHI8gNz7V-KlNyXv5CUfYRRRoTfDK-5tRLTM0ahuO31H9TSp4x7CGCszHCo2LDNzqRDCmB4zn42nqBIdtoUjMMOWjha9oPhlEvGiz80YRyNn5yMixcdLL8xy_Npl2vYv6EyW-AoSg4qCRJAIgHpOFkhsIy5qav5zqpfddkxEkCSJhMguRj5AimKQwkOqTRhiPdDKeDCQFXXhxA",
          "refreshToken": "b345a8de-7d99-41cd-a994-29cc404ee0bd",
          "enabled": false,
        };
        return {
          "code": 200,
          "body": body,
          "error": false,
        };
      } else if (dataString ==
          {"phone": "+94763067706", "otp": "123457"}.toString()) {
        var body = {
          "message": "Invalid OTP/phone",
        };
        return {
          "code": 401,
          "body": body,
          "error": true,
        };
      } else {
        var body = {
          "message": "User is suspended",
        };
        return {
          "code": 403,
          "body": body,
          "error": true,
        };
      }
    } else if (url == '/api/passenger/profileComplete') {
      if (dataString ==
          {
            "email": "avishkar.18@cse.mrt.ac.lk",
            "name": "Avishka Passenger",
            "notificationToken":
                "cVsfNcSvSyS-4cBQ6264-W:APA91bHSnQUe_zeU1RHUicyaP20OrhT_dwObeifUS4WgFSRNLRV2T_D5zkewio6oJXRdy4P-F8xb4hKOugH7NRqjjW2VSmmdt-HPg99KJNuor65XXkHJq8MkJIxZv6g8m6S4bg-9Uzvk",
          }.toString()) {
        var body = {
          "id": "61820de6fd64760c31213444",
          "phone": "+94763067706",
          "email": "avishkar.18@cse.mrt.ac.lk",
          "name": "Avishka Passenger",
          "totalRating": 0,
          "totalRides": 0,
          "notificationToken":
              "cVsfNcSvSyS-4cBQ6264-W:APA91bHSnQUe_zeU1RHUicyaP20OrhT_dwObeifUS4WgFSRNLRV2T_D5zkewio6oJXRdy4P-F8xb4hKOugH7NRqjjW2VSmmdt-HPg99KJNuor65XXkHJq8MkJIxZv6g8m6S4bg-9Uzvk",
          "enabled": true,
          "suspend": null,
        };
        return {
          "code": 200,
          "body": body,
          "error": false,
        };
      } else {
        var body = {
          "message": "User not found",
        };
        return {
          "code": 400,
          "body": body,
          "error": true,
        };
      }
    } else {
      return {};
    }
  }
}

// class MockClient extends Mock implements http.Client {

// }

const String token =
    "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIrOTQ3NjMwNjc3MDYiLCJyb2xlcyI6WyJEUklWRVIiXSwidHlwZSI6ImF1dGgiLCJpYXQiOjE2MzU5MTMxOTAsImV4cCI6MTY3MTkxMzE5MH0.lWqkjQ_78RDv2DrIIHIazgou_4fx8ugqKxchTr-3f2Cno7W9SkS5oZbsRIMDq8pmKvOIo70NU77gbrV-WvvTR_W6aNLZON6axjAV6si3KeZYpB6d-FWkfQh-yGcUiWTM0dzsqHCFmHI8gNz7V-KlNyXv5CUfYRRRoTfDK-5tRLTM0ahuO31H9TSp4x7CGCszHCo2LDNzqRDCmB4zn42nqBIdtoUjMMOWjha9oPhlEvGiz80YRyNn5yMixcdLL8xy_Npl2vYv6EyW-AoSg4qCRJAIgHpOFkhsIy5qav5zqpfddkxEkCSJhMguRj5AimKQwkOqTRhiPdDKeDCQFXXhxA";

void main() {
  group(
    "Auth API test: ",
    () {
      group("Phone auth: ", () {
        test("Success", () async {
          MockClient mockService = MockClient();
          AuthApi api = AuthApi.internal(mockService);

          // when(api.post(
          //     Uri.parse('https://maps.googleapis.com/api/auth/driver/phoneAuth'),
          //     body: {
          //       "phone": '+94711737706',
          //     })).thenAnswer(
          //     (_) async => http.Response(jsonEncode(loginResposne), 200));

          var out = await api.phoneAuth(phone: '+94711737706');
          var expectedBody = {
            "message": "Otp sent",
          };
          expect(
            out,
            {
              "code": 200,
              "body": expectedBody,
              "error": false,
            },
          );
        });

        test("Fail", () async {
          MockClient mockService = MockClient();
          AuthApi api = AuthApi.internal(mockService);
          var out = await api.phoneAuth(phone: '+94763067706');

          var expectedBody = {
            "message": "Unable to generate OTP",
          };
          expect(
            out,
            {
              "code": 500,
              "body": expectedBody,
              "error": true,
            },
          );
        });
      });
      group("Phone otp verify: ", () {
        test("Success", () async {
          MockClient mockService = MockClient();
          AuthApi api = AuthApi.internal(mockService);

          var out = await api.phoneVerify(phone: "+94763067706", otp: "123456");
          var expectedBody = {
            "id": "61820de6fd64760c31213444",
            "phone": "+94763067706",
            "email": null,
            "name": null,
            "totalRating": 0,
            "totalRides": 0,
            "pastRides": null,
            "token":
                "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIrOTQ3NjMwNjc3MDYiLCJyb2xlcyI6WyJEUklWRVIiXSwidHlwZSI6ImF1dGgiLCJpYXQiOjE2MzU5MTMxOTAsImV4cCI6MTY3MTkxMzE5MH0.lWqkjQ_78RDv2DrIIHIazgou_4fx8ugqKxchTr-3f2Cno7W9SkS5oZbsRIMDq8pmKvOIo70NU77gbrV-WvvTR_W6aNLZON6axjAV6si3KeZYpB6d-FWkfQh-yGcUiWTM0dzsqHCFmHI8gNz7V-KlNyXv5CUfYRRRoTfDK-5tRLTM0ahuO31H9TSp4x7CGCszHCo2LDNzqRDCmB4zn42nqBIdtoUjMMOWjha9oPhlEvGiz80YRyNn5yMixcdLL8xy_Npl2vYv6EyW-AoSg4qCRJAIgHpOFkhsIy5qav5zqpfddkxEkCSJhMguRj5AimKQwkOqTRhiPdDKeDCQFXXhxA",
            "refreshToken": "b345a8de-7d99-41cd-a994-29cc404ee0bd",
            "enabled": false,
          };
          expect(
            out,
            {
              "code": 200,
              "body": expectedBody,
              "error": false,
            },
          );
        });

        test("Fail - Invalid otp", () async {
          MockClient mockService = MockClient();
          AuthApi api = AuthApi.internal(mockService);
          var out = await api.phoneVerify(phone: "+94763067706", otp: "123457");

          var expectedBody = {
            "message": "Invalid OTP/phone",
          };
          expect(
            out,
            {
              "code": 401,
              "body": expectedBody,
              "error": true,
            },
          );
        });

        test("Fail - User suspended", () async {
          MockClient mockService = MockClient();
          AuthApi api = AuthApi.internal(mockService);
          var out =
              await api.phoneVerify(phone: "+94763067706", otp: "1234568");

          var expectedBody = {
            "message": "User is suspended",
          };
          expect(
            out,
            {
              "code": 403,
              "body": expectedBody,
              "error": true,
            },
          );
        });
      });
      group("Passenger profile complete: ", () {
        test("Success", () async {
          MockClient mockService = MockClient();
          AuthApi api = AuthApi.internal(mockService);
          var out = await api.profileComplete(
            name: "Avishka Passenger",
            email: "avishkar.18@cse.mrt.ac.lk",
            notificationToken:
                "cVsfNcSvSyS-4cBQ6264-W:APA91bHSnQUe_zeU1RHUicyaP20OrhT_dwObeifUS4WgFSRNLRV2T_D5zkewio6oJXRdy4P-F8xb4hKOugH7NRqjjW2VSmmdt-HPg99KJNuor65XXkHJq8MkJIxZv6g8m6S4bg-9Uzvk",
            token: token,
          );
          var expectedBody = {
            "id": "61820de6fd64760c31213444",
            "phone": "+94763067706",
            "email": "avishkar.18@cse.mrt.ac.lk",
            "name": "Avishka Passenger",
            "totalRating": 0,
            "totalRides": 0,
            "notificationToken":
                "cVsfNcSvSyS-4cBQ6264-W:APA91bHSnQUe_zeU1RHUicyaP20OrhT_dwObeifUS4WgFSRNLRV2T_D5zkewio6oJXRdy4P-F8xb4hKOugH7NRqjjW2VSmmdt-HPg99KJNuor65XXkHJq8MkJIxZv6g8m6S4bg-9Uzvk",
            "enabled": true,
            "suspend": null,
          };
          expect(
            out,
            {
              "code": 200,
              "body": expectedBody,
              "error": false,
            },
          );
        });

        test("Fail", () async {
          MockClient mockService = MockClient();
          AuthApi api = AuthApi.internal(mockService);
          var out = await api.profileComplete(
            name: "Avishka",
            email: "avishkar.18@cse.mrt.ac.lk",
            notificationToken:
                "cVsfNcSvSyS-4cBQ6264-W:APA91bHSnQUe_zeU1RHUicyaP20OrhT_dwObeifUS4WgFSRNLRV2T_D5zkewio6oJXRdy4P-F8xb4hKOugH7NRqjjW2VSmmdt-HPg99KJNuor65XXkHJq8MkJIxZv6g8m6S4bg-9Uzvk",
            token: '',
          );

          var expectedBody = {
            "message": "User not found",
          };
          expect(
            out,
            {
              "code": 400,
              "body": expectedBody,
              "error": true,
            },
          );
        });
      });
    },
  );
}
