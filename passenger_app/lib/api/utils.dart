import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> postRequest(
    {required String urlOld, required Map<String, dynamic> data}) async {
  debugPrint(data.toString());
  var url = Uri.http('ridex.ml', '/api/auth/passenger/phoneAuth');

  try {
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data));

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
  } catch (error) {
    debugPrint(error.toString());
  } finally {}
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

// Map<String> generateSuccessOutput = (response) => {
// 	console.log(response);
// 	return {
// 		data: response.data.results,
// 		message: response.data.message,
// 	}
// }

// const generateErrorOutput = (error) => {
// 	if (error.response)
// 		return {
// 			error: error,
// 			title: error.response.statusText,
// 			code: error.response.status,
// 			message: error.response.data.message
// 		}
// 	else
// 		return {
// 			error: error,
// 			title: error.message,
// 			code: 1,
// 			message: "Cannot connect to the server"
// 		}
// }