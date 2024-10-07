import 'package:students/data/models/tutor_model.dart';
import 'package:students/utils/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class CenterDataSource {
  CenterDataSource();

  Future<List<Tutor>> fetchCenters(
      String phoneNumber,
      double lat,
      double long,
      ) async {
    String url = '${Constants.baseUrl}talkteacher.php?API-Key=${Constants.apiKey}&classtype=center&lat=$lat&long=$long';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Debugging the response

      final List<dynamic> tutorsJson = jsonResponse['data'];
      final List<Tutor> allTutors = tutorsJson.map((json) => Tutor.fromJson(json)).toList();

      // Print the centers
      for (var tutor in allTutors) {
        print("TUTORS CENTERS : ${tutor.id}");
      }

      return allTutors;
    } else {
      throw Exception('Failed to load centers');
    }
  }
}
