import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:students/data/models/courses_model.dart';
import 'package:students/utils/constants.dart';

class CourseDataSource{
  CourseDataSource();

  Future<CourseResponse> fetchCourses() async{
    const String url = '${Constants.baseUrl}courses.php?API-Key=${Constants.apiKey}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final courseResponse = CourseResponse.fromJson(jsonResponse);

      return courseResponse; // Return the list of courses
    } else {
      throw Exception('Failed to load blogs');
    }
  }
}