import 'package:students/data/models/student_profile_model.dart';

class StudentProfileEntity {
  final bool success;
  final StudentProfile studentProfile;

  StudentProfileEntity({
    required this.success,
    required this.studentProfile,
  });

}
