import 'package:passenger_app/api/utils.dart';

Future<void> signUpRequest({required String phone}) async {
  String url = 'http://ridex.ml/api/auth/passenger/phoneAuth';
  await postRequest(
    urlOld: url,
    data: {
      "phone": phone,
    },
  );
}
