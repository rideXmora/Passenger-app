import 'package:get/get.dart';
import 'package:passenger_app/modals/passenger.dart';

class UserController extends GetxController {
  var passenger = Passenger().obs;

  void savePassengerData(dynamic data) {
    passenger.update((val) {
      val!.id = data["id"];
      val.phone = data["phone"];
      val.email = data["email"] == null ? "" : data["email"];
      val.name = data["name"] == null ? "" : data["email"];
      val.totalRating = data["totalRating"];
      val.totalRides = data["totalRides"];
      val.pastRides = List<String>.from(data["pastRides"]);
      val.token = data["token"];
      val.refreshToken = data["refreshToken"];
      val.enabled = data["enabled"];
      val.suspend = data["suspend"] == null ? false : data["suspend"];
    });
  }

  void updatePassengerData(dynamic data) {
    passenger.update((val) {
      val!.id = data["id"];
      val.phone = data["phone"];
      val.email = data["email"] == null ? "" : data["email"];
      val.name = data["name"] == null ? "" : data["email"];
      val.totalRating = data["totalRating"];
      val.totalRides = data["totalRides"];
      val.pastRides = List<String>.from(data["pastRides"]);
      val.enabled = data["enabled"];
      val.suspend = data["suspend"] == null ? false : data["suspend"];
    });
  }
}
