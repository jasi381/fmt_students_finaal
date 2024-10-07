import 'package:students/data/models/teacher_detail_model.dart';

class TeacherDetailsEntity {
  final List<Rating> ratings;
  final String id;
  final String teacher_id;
  final String merithubid;
  final String name;
  final String email;
  final String about;
  final String subject;
  final String location;
  final String experience;
  final String photo;
  final String isVerified;
  final String education;
  final String homePrice;
  final String onlinePrice;
  final String seassion_price;

  TeacherDetailsEntity({
    required this.ratings,
    required this.id,
    required this.teacher_id,
    required this.merithubid,
    required this.name,
    required this.email,
    required this.about,
    required this.subject,
    required this.location,
    required this.experience,
    required this.photo,
    required this.education,
    required this.isVerified,
    required this.homePrice,
    required this.onlinePrice,
    required this.seassion_price,
  });
}
