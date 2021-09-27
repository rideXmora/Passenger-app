import 'package:get/get.dart';
import 'package:passenger_app/api/auth_api.dart';
import 'package:passenger_app/pages/sign_in_up/pages/getting_started_screen.dart';
import 'package:passenger_app/pages/sign_in_up/pages/language_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var languageSelection = 1.obs;
  // SplashScreen data loading
  Future<void> loadData() async {
    await checkLangugae();
  }

  // SignUp loading
  Future<void> signUp({required String phone}) async {
    await signUpRequest(phone: phone);
    // await Future.delayed(Duration(seconds: 2)).then((value) {
    //   Get.offAll(LanguageSelectionScreen());
    // });
  }

  //check language on app loading
  Future<void> checkLangugae() async {
    SharedPreferences store = await SharedPreferences.getInstance();

    if (store.get("lan") == null) {
      Get.to(LanguageSelectionScreen());
      return;
    }
  }

  //add language to local storage
  Future<void> addLangugae(String language) async {
    SharedPreferences store = await SharedPreferences.getInstance();

    store.setString("lan", language);
    Get.to(GettingStartedScreen());
  }
}
