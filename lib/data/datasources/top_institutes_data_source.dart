import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:students/data/models/top_institutes_model.dart';
import 'package:students/utils/constants.dart';


class TopInstitutesDataSource{
  TopInstitutesDataSource();

  Future<TopInstitutesResponse> fetchTopInstitutes()async{

    const String url = '${Constants.baseUrl}bestcenters.php?API-Key=${Constants.apiKey}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final topInstitutesResponse = TopInstitutesResponse.fromJson(jsonResponse);

      return topInstitutesResponse; // Return the list of blogs
    } else {
      throw Exception('Failed to load Top Institutes');
    }

  }
}