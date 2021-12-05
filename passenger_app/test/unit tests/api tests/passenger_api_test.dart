import 'package:passenger_app/api/passenger_api.dart';
import 'package:passenger_app/api/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements ApiUtils {
  Future<Map<dynamic, dynamic>> putRequest(
      {required String url,
      required Map<String, dynamic> data,
      required String token}) async {
    var dataString = data.toString();
    if (url == '/api/passenger/profileUpdate') {
      if (dataString ==
          {
            "email": "mailkavinda@cse.mrt.ac.lk",
            "name": "Kavinda passenger",
            "notificationToken":
                "cVsfNcSvSyS-4cBQ6264-W:APA91bHSnQUe_zeU1RHUicyaP20OrhT_dwObeifUS4WgFSRNLRV2T_D5zkewio6oJXRdy4P-F8xb4hKOugH7NRqjjW2VSmmdt-HPg99KJNuor65XXkHJq8MkJIxZv6g8m6S4bg-9Uzvk",
          }.toString()) {
        var body = {
          "id": "61820de6fd64760c31213444",
          "phone": "+94763067706",
          "email": "mailkavinda@cse.mrt.ac.lk",
          "name": "Kavinda passenger",
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
          "message": "Database error",
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

  Future<Map<dynamic, dynamic>> getRequest(
      {required String url, required String token}) async {
    if (url == '/api/passenger/profile') {
      if (token == passengerToken) {
        var body = {
          "id": "61820de6fd64760c31213444",
          "phone": "+94763067706",
          "email": "avishkar.18@cse.mrt.ac.lk",
          "name": "Avishka Passenger",
          "totalRating": 4,
          "totalRides": 29,
          "notificationToken":
              "cVsfNcSvSyS-4cBQ6264-W:APA91bHSnQUe_zeU1RHUicyaP20OrhT_dwObeifUS4WgFSRNLRV2T_D5zkewio6oJXRdy4P-F8xb4hKOugH7NRqjjW2VSmmdt-HPg99KJNuor65XXkHJq8MkJIxZv6g8m6S4bg-9Uzvk",
          "enabled": true,
          "suspend": false
        };
        return {
          "code": 200,
          "body": body,
          "error": false,
        };
      } else {
        var body = {
          "message": "Forbidden",
        };
        return {
          "code": 403,
          "body": body,
          "error": true,
        };
      }
    } else if (url == '/api/passenger/ride/past') {
      if (token == passengerToken) {
        var body = [
          {
            "id": "61820de6fd64760c31213444",
            "rideRequest": {
              "id": "61820de6fd64760c14264860",
              "passenger": {
                "id": "61820de6fd64760c45382739",
                "phone": "+94763067706",
                "name": "Avishka Passenger",
                "rating": 3
              },
              "startLocation": {"x": 23.256321, "y": 12.253654},
              "endLocation": {"x": 28.235689, "y": 13.235452},
              "distance": 23562,
              "vehicleType": "THREE_WHEELER",
              "status": "ACCEPTED",
              "driver": {
                "id": "61820de6fd64760c56483903",
                "phone": "+94711737706",
                "name": "Avishka Driver",
                "vehicle": {
                  "number": "CAB 1235",
                  "vehicleType": "THREE_WHEELER",
                  "model": "Toyota"
                },
                "rating": 4
              },
              "organization": {
                "id": "61820de6fd64760c31213638",
                "name": "Avishka Org",
              },
              "timestamp": 1636377686
            },
            "payment": 523.4,
            "rideStatus": "FINISHED"
          },
        ];
        return {
          "code": 200,
          "body": body,
          "error": false,
        };
      } else {
        var body = {
          "message": "Forbidden",
        };
        return {
          "code": 403,
          "body": body,
          "error": true,
        };
      }
    } else {
      return {};
    }
  }
}

const String passengerToken =
    "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIrOTQ3NjMwNjc3MDYiLCJyb2xlcyI6WyJEUklWRVIiXSwidHlwZSI6ImF1dGgiLCJpYXQiOjE2MzU5MTMxOTAsImV4cCI6MTY3MTkxMzE5MH0.lWqkjQ_78RDv2DrIIHIazgou_4fx8ugqKxchTr-3f2Cno7W9SkS5oZbsRIMDq8pmKvOIo70NU77gbrV-WvvTR_W6aNLZON6axjAV6si3KeZYpB6d-FWkfQh-yGcUiWTM0dzsqHCFmHI8gNz7V-KlNyXv5CUfYRRRoTfDK-5tRLTM0ahuO31H9TSp4x7CGCszHCo2LDNzqRDCmB4zn42nqBIdtoUjMMOWjha9oPhlEvGiz80YRyNn5yMixcdLL8xy_Npl2vYv6EyW-AoSg4qCRJAIgHpOFkhsIy5qav5zqpfddkxEkCSJhMguRj5AimKQwkOqTRhiPdDKeDCQFXXhxA";

void main() {
  group(
    "Passenegr API test: ",
    () {
      group("Get passenger details: ", () {
        test("Success", () async {
          MockClient mockService = MockClient();
          PassengerApi api = PassengerApi.internal(mockService);
          var out = await api.profile(token: passengerToken);
          var expectedBody = {
            "id": "61820de6fd64760c31213444",
            "phone": "+94763067706",
            "email": "avishkar.18@cse.mrt.ac.lk",
            "name": "Avishka Passenger",
            "totalRating": 4,
            "totalRides": 29,
            "notificationToken":
                "cVsfNcSvSyS-4cBQ6264-W:APA91bHSnQUe_zeU1RHUicyaP20OrhT_dwObeifUS4WgFSRNLRV2T_D5zkewio6oJXRdy4P-F8xb4hKOugH7NRqjjW2VSmmdt-HPg99KJNuor65XXkHJq8MkJIxZv6g8m6S4bg-9Uzvk",
            "enabled": true,
            "suspend": false
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
          PassengerApi api = PassengerApi.internal(mockService);
          var out = await api.profile(token: '');

          var expectedBody = {
            "message": "Forbidden",
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
      group("Passenger profile update: ", () {
        test("Success", () async {
          MockClient mockService = MockClient();
          PassengerApi api = PassengerApi.internal(mockService);
          var out = await api.profileUpdate(
            name: "Kavinda passenger",
            email: "mailkavinda@cse.mrt.ac.lk",
            notificationToken:
                "cVsfNcSvSyS-4cBQ6264-W:APA91bHSnQUe_zeU1RHUicyaP20OrhT_dwObeifUS4WgFSRNLRV2T_D5zkewio6oJXRdy4P-F8xb4hKOugH7NRqjjW2VSmmdt-HPg99KJNuor65XXkHJq8MkJIxZv6g8m6S4bg-9Uzvk",
            token: passengerToken,
          );
          var expectedBody = {
            "id": "61820de6fd64760c31213444",
            "phone": "+94763067706",
            "email": "mailkavinda@cse.mrt.ac.lk",
            "name": "Kavinda passenger",
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
          PassengerApi api = PassengerApi.internal(mockService);
          var out = await api.profileUpdate(
            name: "kavinda",
            email: "kavinda.18@cse.mrt.ac.lk",
            notificationToken:
                "cVsfNcSvSyS-4cBQ6264-W:APA91bHSnQUe_zeU1RHUicyaP20OrhT_dwObeifUS4WgFSRNLRV2T_D5zkewio6oJXRdy4P-F8xb4hKOugH7NRqjjW2VSmmdt-HPg99KJNuor65XXkHJq8MkJIxZv6g8m6S4bg-9Uzvk",
            token: '',
          );

          var expectedBody = {
            "message": "Database error",
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
      group("Get past rides list: ", () {
        test("Success", () async {
          MockClient mockService = MockClient();
          PassengerApi api = PassengerApi.internal(mockService);
          var out = await api.past(token: passengerToken);
          var expectedBody = [
            {
              "id": "61820de6fd64760c31213444",
              "rideRequest": {
                "id": "61820de6fd64760c14264860",
                "passenger": {
                  "id": "61820de6fd64760c45382739",
                  "phone": "+94763067706",
                  "name": "Avishka Passenger",
                  "rating": 3
                },
                "startLocation": {"x": 23.256321, "y": 12.253654},
                "endLocation": {"x": 28.235689, "y": 13.235452},
                "distance": 23562,
                "vehicleType": "THREE_WHEELER",
                "status": "ACCEPTED",
                "driver": {
                  "id": "61820de6fd64760c56483903",
                  "phone": "+94711737706",
                  "name": "Avishka Driver",
                  "vehicle": {
                    "number": "CAB 1235",
                    "vehicleType": "THREE_WHEELER",
                    "model": "Toyota"
                  },
                  "rating": 4
                },
                "organization": {
                  "id": "61820de6fd64760c31213638",
                  "name": "Avishka Org",
                },
                "timestamp": 1636377686
              },
              "payment": 523.4,
              "rideStatus": "FINISHED"
            },
          ];
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
          PassengerApi api = PassengerApi.internal(mockService);
          var out = await api.past(token: '');

          var expectedBody = {
            "message": "Forbidden",
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
    },
  );
}
