import 'package:students/data/models/courses_model.dart';

class CoursesEntity {
  final bool success;
  final List<CourseItem> courses;

  CoursesEntity({
    required this.success,
    required this.courses,
  });

}