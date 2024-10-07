import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:students/data/models/subjects_model.dart';
import 'package:students/utils/constants.dart';

class SubjectsDataSource {
  SubjectsDataSource();

  Future<SubjectsModel> fetchSubjects() async {
    const String url = '${Constants.baseUrl}subject.php?API-Key=${Constants.apiKey}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return SubjectsModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load subjects');
    }
  }
}
