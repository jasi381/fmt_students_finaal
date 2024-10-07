import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:students/data/models/blogs_model.dart';
import 'package:students/utils/constants.dart';


class BlogsDataSource {
  BlogsDataSource();

  Future<BlogResponse> fetchBlogs() async {
    const String url = '${Constants.baseUrl}blogs.php?API-Key=${Constants.apiKey}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final blogResponse = BlogResponse.fromJson(jsonResponse);

      return blogResponse; // Return the list of blogs
    } else {
      throw Exception('Failed to load blogs');
    }
  }
}
