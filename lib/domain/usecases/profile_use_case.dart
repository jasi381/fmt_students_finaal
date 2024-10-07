import 'package:students/data/repos/student_profile_repo.dart';
import 'package:students/domain/entities/student_profile_entity.dart';

class ProfileUseCase{
  final StudentProfileRepo repo;

  ProfileUseCase(this.repo);

  Future<StudentProfileEntity> call(String phone) async{
    final profileModel = await repo.fetchStudentProfile(phone);
    return StudentProfileEntity(success: profileModel.success, studentProfile: profileModel.studentProfile);
  }
}