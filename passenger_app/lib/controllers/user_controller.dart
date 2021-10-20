import 'package:get/get.dart';
import 'package:passenger_app/modals/passenger.dart';

class UserController extends GetxController {
  var passenger = Passenger(
    id: "",
    email: "",
    enabled: false,
    name: "",
    pastRides: [],
    phone: "",
    refreshToken: "",
    suspend: false,
    token: "",
    totalRating: 0,
    totalRides: 0,
  ).obs;

  void savePassengerData(dynamic data) {
    passenger.update((val) {
      val!.id = data["id"];
      val.phone = data["phone"];
      val.email = data["email"] == null ? "" : data["email"];
      val.name = data["name"] == null ? "" : data["name"];
      val.totalRating = data["totalRating"];
      val.totalRides = data["totalRides"];
      val.pastRides =
          data["pastRides"] == null ? [] : List<String>.from(data["pastRides"]);
      val.token = data["token"];
      val.refreshToken = data["refreshToken"];
      val.enabled = data["enabled"] == null ? false : data["enabled"];
      val.suspend = data["suspend"] == null ? false : data["suspend"];
    });
  }

//change
  void updatePassengerData(
    dynamic data,
    String token,
    String refreshToken,
  ) {
    passenger.update((val) {
      val!.id = data["id"];
      val.phone = data["phone"];
      val.email = data["email"] == null ? "" : data["email"];
      val.name = data["name"] == null ? "" : data["name"];
      val.totalRating = data["totalRating"];
      val.totalRides = data["totalRides"];
      val.pastRides =
          data["pastRides"] == null ? [] : List<String>.from(data["pastRides"]);
      val.token = token;
      val.refreshToken = refreshToken;
      val.enabled = data["enabled"] == null ? false : data["enabled"];
      val.suspend = data["suspend"] == null ? false : data["suspend"];
    });
  }

  void signOutUser() {
    passenger.update((val) {
      val!.id = "";
      val.email = "";
      val.enabled = false;
      val.name = "";
      val.pastRides = [];
      val.phone = "";
      val.refreshToken = "";
      val.suspend = false;
      val.token = "";
      val.totalRating = 0;
      val.totalRides = 0;
    });
  }
}
