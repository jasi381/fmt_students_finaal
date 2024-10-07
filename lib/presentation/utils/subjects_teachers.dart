import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:students/presentation/utils/check_bal.dart';
import 'package:students/utils/constants.dart';

class TeacherService {
  Future<List<Teacher>> fetchTeachers(String subject) async {
    final phone = await WalletService.getPhoneNumber();
    final response = await http.get(Uri.parse(
        "${Constants.baseUrl}subjectteacher.php?API-Key=${Constants.apiKey}&subject=$subject&phone=$phone"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        List<Teacher> teachers = (data['data'] as List?)
            ?.map((json) => Teacher.fromJson(json))
            .whereType<Teacher>()
            .toList() ?? [];

        return teachers;
      } else {
        throw Exception('Failed to load teachers');
      }
    } else {
      throw Exception('Failed to connect to API');
    }
  }
}

class Teacher {
  final String? id;
  final String? name;
  final String? photo;
  final String? subject;
  final String? location;
  final String? education;
  final String? username;
  final String? experience;
  final bool? best;
  final String? voice;
  final String? video;

  Teacher({
    this.id,
    this.name,
    this.photo,
    this.subject,
    this.location,
    this.education,
    this.username,
    this.experience,
    this.best,
    this.voice,
    this.video,
  });

  factory Teacher.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Teacher();

    return Teacher(
      id: json['id'] as String?,
      name: json['name'] as String?,
      photo: json['photo'] as String?,
      subject: json['subject'] as String?,
      location: json['location'] as String?,
      education: json['education'] as String?,
      username: json['username'] as String?,
      experience: json['experiance']?.toString(),
      best: json['best'] as bool?,
      voice: json['voice']?.toString(),
      video: json['video']?.toString(),
    );
  }
}