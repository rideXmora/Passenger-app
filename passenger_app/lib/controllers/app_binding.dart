import 'package:get/get.dart';
import 'package:passenger_app/controllers/auth_controller.dart';
import 'package:passenger_app/controllers/controller.dart';
import 'package:passenger_app/controllers/map_controller.dart';
import 'package:passenger_app/controllers/ride_controller.dart';
import 'package:passenger_app/controllers/user_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    print("app binding");
    Get.put(Controller());
    Get..put(AuthController());
    Get.put(MapController());
    Get.put(RideController());
    Get.put(UserController());
  }
}
