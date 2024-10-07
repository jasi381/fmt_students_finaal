import 'package:students/data/repos/home_classes_repo.dart';
import 'package:students/domain/entities/home_class_entity.dart';

class HomeClassUseCase{
  final HomeClassesRepo homeClassesRepo;

  HomeClassUseCase(this.homeClassesRepo);

  Future<HomeClassEntity> call(String teacherId) async{
    final homeClassesModel = await homeClassesRepo.getSchedule(teacherId);

    return HomeClassEntity(success: homeClassesModel.success, data: homeClassesModel.data);
  }
}