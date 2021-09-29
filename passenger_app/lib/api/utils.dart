import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:passenger_app/utils/config.dart';

Future<Map<dynamic, dynamic>> postRequest(
    {required String url, required Map<String, dynamic> data}) async {
  try {
    var completeUrl = Uri.http(BASEURL, url);
    var jsonEncodedData = jsonEncode(data);

    var response = await http.post(completeUrl,
        headers: {"Content-Type": "application/json"}, body: jsonEncodedData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return generateSuccessOutput(response);
    } else {
      return generateErrorOutput(jsonDecode(response.body));
    }
  } catch (error) {
    Get.snackbar("Something is wrong" + "!!!", "Please try again");
    debugPrint("try catch Error : " + error.toString());
    return {"error": true};
  }

  // } catch (error) {
  //   debugPrint("catch" + error.toString());
  //   return generateErrorOutput(error);
  //   //return generateErrorOutput(error);
  // } finally {}
  // try {

  // 	var response = await axios.get(url);
  // 	//return generateSuccessOutput(response);
  // } catch (error) {
  // 	//return generateErrorOutput(error);
  // }
}

// export const postRequest = async (url, data) => {
// 	try {
// 		let response = await axios.post(url, data);
// 		return generateSuccessOutput(response);
// 	} catch (error) {
// 		return generateErrorOutput(error);
// 	}
// };

// export const putRequest = async (url, data, headers = {}) => {
// 	try {
// 		let response = (data) ? await axios.put(url, data, headers) : await axios.put(url, headers);
// 		return generateSuccessOutput(response);
// 	} catch (error) {
// 		return generateErrorOutput(error);
// 	}
// };

// export const deleteRequest = async (url) => {
// 	try {
// 		let response = await axios.delete(url);
// 		return generateSuccessOutput(response);
// 	} catch (error) {
// 		return generateErrorOutput(error);
// 	}
// };

Map<dynamic, dynamic> generateSuccessOutput(response) {
  debugPrint("generateSuccessOutput : " + response.body);
  return {
    "code": response.statusCode,
    "body": jsonDecode(response.body),
    "error": false,
  };
}

Map<dynamic, dynamic> generateErrorOutput(error) {
  if (error["message"] != null) {
    Get.snackbar(error["message"] + "!!!", "Please try again");
    debugPrint("generateErrorOutput : " + error.toString());
    return {"error": true};
  } else {
    Get.snackbar("Something is wrong" + "!!!", "Please try again");
    debugPrint("generateErrorOutput Else : " + error.toString());
    return {"error": true};
  }
}
