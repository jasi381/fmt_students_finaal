import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:students/data/models/student_profile_model.dart';
import 'package:students/utils/constants.dart';

class StudentProfileDataSource {
  StudentProfileDataSource();

  Future<StudentProfileModel> fetchProfile(String phone) async {
    String url =
        '${Constants.baseUrl}studentprofile.php?API-Key=${Constants.apiKey}&phone=$phone';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return StudentProfileModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile ');
    }
  }
}
