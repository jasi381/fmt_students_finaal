import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:students/data/models/tutor_model.dart';
import 'package:students/utils/constants.dart';

class TutorDataSource {
  TutorDataSource();

  Future<List<Tutor>> fetchTutors(ApiType type, {String? phoneNumber}) async {
    // Construct the URL with the optional phone number parameter
    String url = '${Constants.baseUrl}talkteacher.php?API-Key=${Constants.apiKey}&classtype=${type.value}';

    // If phoneNumber is provided, append it as a query parameter
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      url += '&phone=$phoneNumber';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final List<dynamic> tutorsJson = jsonResponse['data'];
      final List<Tutor> allTutors =
      tutorsJson.map((json) => Tutor.fromJson(json)).toList();

      return allTutors; // Return all tutors without pagination
    } else {
      throw Exception('Failed to load tutors');
    }
  }
}


enum ApiType {
  home,
  talk,
}

extension StatusExtension on ApiType {
  String get value {
    switch (this) {
      case ApiType.home:
        return 'home';
      case ApiType.talk:
        return 'talk';
    }
  }
}