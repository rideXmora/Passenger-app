import 'package:get/get.dart';
import 'package:passenger_app/api/auth_api.dart';
import 'package:passenger_app/api/passenger_api.dart';
import 'package:passenger_app/api/passenger_ride_api.dart';
import 'package:passenger_app/api/utils.dart';
import 'package:passenger_app/controllers/auth_controller.dart';
import 'package:passenger_app/controllers/map_controller.dart';
import 'package:passenger_app/controllers/ride_controller.dart';
import 'package:passenger_app/controllers/user_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    print("app binding");
    Get.put(AuthController(AuthApi(ApiUtils()), PassengerApi(ApiUtils())));
    Get.put(MapController(ApiUtils()));
    Get.put(RideController(PassengerRideApi(ApiUtils())));
    Get.put(UserController(PassengerApi(ApiUtils())));
  }
}
