import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:students/data/models/teacher_detail_model.dart';
import 'package:students/utils/constants.dart';

class TeacherDetailsDataSource {
  TeacherDetailsDataSource();

  Future<TeacherDetailsResponse> fetchTeacherProfile(String id) async {
    String url =
        '${Constants.baseUrl}teacherdetails.php?API-Key=${Constants.apiKey}&teacherid=$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("DETAILS RESPONSE : ${response.body}");
      return TeacherDetailsResponse.fromJson(json.decode(response.body));
    } else {
      print("DETAILS RESPONSE ERROR : ${response.body}");
      throw Exception('Failed to load teacher profile');
    }
  }
}
