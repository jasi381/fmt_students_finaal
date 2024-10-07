import 'package:students/data/repos/teacher_detail_repo.dart';
import 'package:students/domain/entities/teacher_details_entity.dart';

class TeacherDetailsUseCase {
  final TeacherDetailRepo repo;

  TeacherDetailsUseCase(this.repo);

  Future<TeacherDetailsEntity> call(String id) async {
    final teacherDetailModel = await repo.fetchTeacherDetails(id);

    return TeacherDetailsEntity(
      ratings: teacherDetailModel.ratings,
      id: teacherDetailModel.teacherProfile.id,
      teacher_id: teacherDetailModel.teacherProfile.teacherId,
      merithubid: teacherDetailModel.teacherProfile.merithubid,
      name: teacherDetailModel.teacherProfile.name,
      email: teacherDetailModel.teacherProfile.email,
      about: teacherDetailModel.teacherProfile.about,
      subject: teacherDetailModel.teacherProfile.subject,
      location: teacherDetailModel.teacherProfile.location,
      experience: teacherDetailModel.teacherProfile.experience,
      photo: teacherDetailModel.teacherProfile.photo,
      education: teacherDetailModel.teacherProfile.education,
      isVerified: teacherDetailModel.teacherProfile.isVerified,
      homePrice: teacherDetailModel.teacherProfile.homePrice,
      onlinePrice: teacherDetailModel.teacherProfile.onlinePrice,
      seassion_price: teacherDetailModel.teacherProfile.seassionPrice
    );
  }
}
