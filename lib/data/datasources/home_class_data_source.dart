import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:students/data/models/home_classes_model.dart';
import 'package:students/utils/constants.dart';

class HomeClassDataSource {
  HomeClassDataSource();

  Future<HomeClassResponse> fetchSchedule(String teacherId) async {
    String url = '${Constants.baseUrl}timetable.php?API-Key=${Constants.apiKey}&teacher=$teacherId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final homeClassesResponse = HomeClassResponse.fromJson(jsonResponse);
      return homeClassesResponse;
    } else {
      throw Exception('Failed to load schedule');
    }
  }
}