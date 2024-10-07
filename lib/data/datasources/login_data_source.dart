import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:students/data/models/login_model.dart';
import 'package:students/data/models/response_model.dart';
import 'package:students/utils/constants.dart';

class LoginDatasource {
  Future<ResponseModel> login(LoginModel loginModel) async {
    const String url =
        '${Constants.baseUrl}studentlogin.php?API-Key=${Constants.apiKey}';

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(loginModel.toJson()));

    debugPrint("Mobile Number Successfully Updated");

    if (response.statusCode != 200) {
      debugPrint("Failed Activity");
      throw Exception('Failed to upload user details');
    }

    final responseJson = json.decode(response.body);
    return ResponseModel.fromJson(responseJson);
  }
}
