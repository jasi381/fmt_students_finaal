import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:students/domain/entities/courses_entity.dart';
import 'package:students/domain/usecases/course_use_case.dart';

class CourseProvider extends ChangeNotifier{
  final CourseUseCase courseUseCase;

  CourseProvider(this.courseUseCase);

  CoursesEntity? _courses;
  bool _isCourseLoading = false;
  String? _error;

  CoursesEntity? get courses => _courses;
  bool get isCourseLoading => _isCourseLoading;
  String? get error => _error;


  Future<void> loadCourses() async {
    _isCourseLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await courseUseCase.call();

      _courses = CoursesEntity(
          success: _courses!.success,
          courses: _courses!.courses
      );

      _isCourseLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print("Filtered Subjects: ${courses?.courses.length}");
      }
    } catch (e) {
      _error = e.toString();
      _isCourseLoading = false;
      if (kDebugMode) {
        print("Error: ${e.toString()}");
      }
      notifyListeners();
    }
  }
}