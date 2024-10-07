import 'package:students/data/datasources/teacher_details_data_source.dart';
import 'package:students/data/models/teacher_detail_model.dart';

class TeacherDetailRepo {
  final TeacherDetailsDataSource teacherDetailsDataSource;

  TeacherDetailRepo(this.teacherDetailsDataSource);

  Future<TeacherDetailsResponse> fetchTeacherDetails(String id) {
    return teacherDetailsDataSource.fetchTeacherProfile(id);
  }
}
