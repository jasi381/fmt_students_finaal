import 'package:students/data/datasources/student_profile_data_source.dart';
import 'package:students/data/models/student_profile_model.dart';

class StudentProfileRepo{
  final StudentProfileDataSource studentProfileDataSource;

  StudentProfileRepo(this.studentProfileDataSource);

  Future<StudentProfileModel>  fetchStudentProfile(String phone){
    return studentProfileDataSource.fetchProfile(phone);
  }
}