import 'package:students/data/datasources/courses_data_source.dart';
import 'package:students/data/models/courses_model.dart';

class CoursesRepo{
  final CourseDataSource courseDataSource;

  CoursesRepo( this.courseDataSource);

  Future<CourseResponse>getCourses(){
    return courseDataSource.fetchCourses();
  }
}