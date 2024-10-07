import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:students/data/models/response_model.dart';
import 'package:students/data/models/register_model.dart';
import 'package:students/utils/constants.dart';

class RegisterDatasource {
  Future<ResponseModel> register(RegisterModel registerModel) async {
    const String url =
        '${Constants.baseUrl}studentregistration.php?API-Key=${Constants.apiKey}';

    final response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(registerModel.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Failed to upload user details');
    }

    final responseJson = json.decode(response.body);
    return ResponseModel.fromJson(responseJson);
  }
}
