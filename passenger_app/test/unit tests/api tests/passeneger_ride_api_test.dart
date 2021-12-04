import 'package:flutter/material.dart';
import 'package:passenger_app/api/passenger_api.dart';
import 'package:passenger_app/api/passenger_ride_api.dart';
import 'package:passenger_app/api/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:passenger_app/modals/location.dart';

class MockClient extends Mock implements ApiUtils {
  Future<Map<dynamic, dynamic>> postRequest(
      {required String url,
      required Map<String, dynamic> data,
      required String token}) async {
    var dataString = data.toString();
    if (url == '/api/passenger/ride/request') {
      if (dataString ==
              {
                "startLocation": {"x": 23.256321, "y": 12.253654},
                "endLocation": {"x": 28.235689, "y": 13.235452},
                "distance": 23562.0,
                "vehicleType": "THREE_WHEELER",
              }.toString() &&
          token == passengerToken) {
        var body = {
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
          "status": "PENDING",
          "driver": {
            "id": "",
            "phone": "",
            "name": "",
            "vehicle": {
              "number": "",
              "vehicleType": "THREE_WHEELER",
              "model": ""
            },
            "rating": 4
          },
          "organization": {
            "id": "",
            "name": "",
          },
          "timestamp": 1636377686
        };
        return {
          "code": 201,
          "body": body,
          "error": false,
        };
      } else {
        var body = {
          "message": "Invalid request",
        };
        return {
          "code": 400,
          "body": body,
          "error": true,
        };
      }
    } else if (url == '/api/passenger/ride/getRide') {
      if (dataString ==
              {
                "id": "61820de6fd64760c31213444",
              }.toString() &&
          token == passengerToken) {
        var body = {
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
          "rideStatus": "ACCEPTED"
        };
        return {
          "code": 201,
          "body": body,
          "error": false,
        };
      } else {
        var body = {
          "message": "Invalid request",
        };
        return {
          "code": 400,
          "body": body,
          "error": true,
        };
      }
    } else if (url == '/api/passenger/ride/request/timeout') {
      if (dataString ==
              {
                "id": "61820de6fd64760c31213444",
              }.toString() &&
          token == passengerToken) {
        var body = {
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
            "status": "FINISHED",
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
        };
        return {
          "code": 200,
          "body": body,
          "error": false,
        };
      } else {
        var body = {
          "message": "Invalid request",
        };
        return {
          "code": 400,
          "body": body,
          "error": true,
        };
      }
    } else if (url == '/api/passenger/ride/confirm') {
      if (dataString ==
              {
                "id": "61820de6fd64760c31213444",
                "passengerFeedback": "Good driver",
                "driverRating": 5
              }.toString() &&
          token == passengerToken) {
        var body = {
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
            "status": "FINISHED",
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
        };
        return {
          "code": 201,
          "body": body,
          "error": false,
        };
      } else {
        var body = {
          "message": "Invalid request",
        };
        return {
          "code": 400,
          "body": body,
          "error": true,
        };
      }
    } else if (url == '/api/passenger/ride/complain') {
      if (dataString ==
              {
                "id": "61820de6fd64760c31213444",
                "complain": "bad driver",
              }.toString() &&
          token == passengerToken) {
        var body = {
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
            "status": "FINISHED",
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
        };
        return {
          "code": 201,
          "body": body,
          "error": false,
        };
      } else {
        var body = {
          "message": "Invalid request",
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

const String passengerToken =
    "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIrOTQ3NjMwNjc3MDYiLCJyb2xlcyI6WyJEUklWRVIiXSwidHlwZSI6ImF1dGgiLCJpYXQiOjE2MzU5MTMxOTAsImV4cCI6MTY3MTkxMzE5MH0.lWqkjQ_78RDv2DrIIHIazgou_4fx8ugqKxchTr-3f2Cno7W9SkS5oZbsRIMDq8pmKvOIo70NU77gbrV-WvvTR_W6aNLZON6axjAV6si3KeZYpB6d-FWkfQh-yGcUiWTM0dzsqHCFmHI8gNz7V-KlNyXv5CUfYRRRoTfDK-5tRLTM0ahuO31H9TSp4x7CGCszHCo2LDNzqRDCmB4zn42nqBIdtoUjMMOWjha9oPhlEvGiz80YRyNn5yMixcdLL8xy_Npl2vYv6EyW-AoSg4qCRJAIgHpOFkhsIy5qav5zqpfddkxEkCSJhMguRj5AimKQwkOqTRhiPdDKeDCQFXXhxA";

void main() {
  group(
    "Passenger Ride API test: ",
    () {
      group("Request ride: ", () {
        test("Success", () async {
          MockClient mockService = MockClient();
          PassengerRideApi api = PassengerRideApi.internal(mockService);
          var out = await api.request(
              startLocation: Location(x: 23.256321, y: 12.253654),
              endLocation: Location(x: 28.235689, y: 13.235452),
              distance: 23562,
              vehicleType: "THREE_WHEELER",
              token: passengerToken);
          var expectedBody = {
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
            "status": "PENDING",
            "driver": {
              "id": "",
              "phone": "",
              "name": "",
              "vehicle": {
                "number": "",
                "vehicleType": "THREE_WHEELER",
                "model": ""
              },
              "rating": 4
            },
            "organization": {
              "id": "",
              "name": "",
            },
            "timestamp": 1636377686
          };

          expect(
            out,
            {
              "code": 201,
              "body": expectedBody,
              "error": false,
            },
          );
        });

        test("Fail", () async {
          MockClient mockService = MockClient();
          PassengerRideApi api = PassengerRideApi.internal(mockService);
          var out = await api.request(
              startLocation: Location(x: 23.256321, y: 12.253654),
              endLocation: Location(x: 28.235689, y: 13.235452),
              distance: 23562,
              vehicleType: "THREE_WHEELER",
              token: '');

          var expectedBody = {
            "message": "Invalid request",
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

      group("Get ride details: ", () {
        test("Success", () async {
          MockClient mockService = MockClient();
          PassengerRideApi api = PassengerRideApi.internal(mockService);
          var out = await api.getRide(
              id: "61820de6fd64760c31213444", token: passengerToken);
          var expectedBody = {
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
            "rideStatus": "ACCEPTED"
          };

          expect(
            out,
            {
              "code": 201,
              "body": expectedBody,
              "error": false,
            },
          );
        });

        test("Fail", () async {
          MockClient mockService = MockClient();
          PassengerRideApi api = PassengerRideApi.internal(mockService);
          var out =
              await api.getRide(id: "61820de6fd64760c31213444", token: '');

          var expectedBody = {
            "message": "Invalid request",
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

      group("Cancel ride: ", () {
        test("Success", () async {
          MockClient mockService = MockClient();
          PassengerRideApi api = PassengerRideApi.internal(mockService);
          var out = await api.cancel(
              id: "61820de6fd64760c31213444", token: passengerToken);
          var expectedBody = {
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
              "status": "FINISHED",
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
          PassengerRideApi api = PassengerRideApi.internal(mockService);
          var out = await api.cancel(id: "61820de6fd64760c31213444", token: '');

          var expectedBody = {
            "message": "Invalid request",
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

      group("Finish ride: ", () {
        test("Success", () async {
          MockClient mockService = MockClient();
          PassengerRideApi api = PassengerRideApi.internal(mockService);
          var out = await api.confirm(
              id: "61820de6fd64760c31213444",
              passengerFeedback: "Good driver",
              driverRating: 5,
              token: passengerToken);
          var expectedBody = {
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
              "status": "FINISHED",
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
          };

          expect(
            out,
            {
              "code": 201,
              "body": expectedBody,
              "error": false,
            },
          );
        });

        test("Fail", () async {
          MockClient mockService = MockClient();
          PassengerRideApi api = PassengerRideApi.internal(mockService);
          var out = await api.confirm(
              id: "61820de6fd64760c31213444",
              passengerFeedback: "",
              driverRating: 5,
              token: '');

          var expectedBody = {
            "message": "Invalid request",
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

      group("Add complain: ", () {
        test("Success", () async {
          MockClient mockService = MockClient();
          PassengerRideApi api = PassengerRideApi.internal(mockService);
          var out = await api.complain(
              id: "61820de6fd64760c31213444",
              complain: "bad driver",
              token: passengerToken);
          var expectedBody = {
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
              "status": "FINISHED",
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
          };

          expect(
            out,
            {
              "code": 201,
              "body": expectedBody,
              "error": false,
            },
          );
        });

        test("Fail", () async {
          MockClient mockService = MockClient();
          PassengerRideApi api = PassengerRideApi.internal(mockService);
          var out = await api.complain(
              id: "61820de6fd64760c45382739", complain: '', token: '');

          var expectedBody = {
            "message": "Invalid request",
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
