import 'package:students/data/repos/home_repo.dart';
import 'package:students/domain/entities/blogs_entity.dart';
import 'package:students/domain/entities/subjects_entity.dart';
import 'package:students/domain/entities/top_institutes_entity.dart';

class HomeUseCase {
  final HomeRepo homeRepo;

  HomeUseCase(this.homeRepo);

  Future<SubjectsEntity> call() async {
    final subjectsModel = await homeRepo.getSubjects();
    return SubjectsEntity(
      isSuccess: subjectsModel.success,
      subjectList: subjectsModel.subjects,
    );
  }

  Future<BlogEntity> call1() async {
    final blogsModel = await homeRepo.getBlogs();
    return BlogEntity(success: blogsModel.success, blogs: blogsModel.data);
  }

  Future<TopInstitutesEntity> call2() async {
    final topInstitutesModel = await homeRepo.getTopInstitutes();
    return TopInstitutesEntity(
        success: topInstitutesModel.success,
        institutes: topInstitutesModel.data);
  }
}
