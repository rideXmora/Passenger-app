import 'package:get/get.dart';
import 'package:passenger_app/pages/sign_in_up/pages/language_selection_screen.dart';

class AuthController extends GetxController {
  // SplashScreen loading
  Future<void> loadData() async {
    await Future.delayed(Duration(seconds: 2)).then((value) {
      Get.offAll(LanguageSelectionScreen());
    });
  }
}
