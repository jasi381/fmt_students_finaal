import 'package:students/data/repos/courses_repo.dart';
import 'package:students/domain/entities/courses_entity.dart';

class CourseUseCase {
  final CoursesRepo courseRepo;

  CourseUseCase(this.courseRepo);

  Future<CoursesEntity> call() async{
    final courseModel = await courseRepo.getCourses();
    return CoursesEntity(success: courseModel.success, courses: courseModel.data);
  }

}