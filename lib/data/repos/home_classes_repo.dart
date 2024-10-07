import 'package:students/data/datasources/home_class_data_source.dart';
import 'package:students/data/models/home_classes_model.dart';

class HomeClassesRepo{
  final HomeClassDataSource homeClassDataSource;

  HomeClassesRepo(this.homeClassDataSource);

  Future<HomeClassResponse> getSchedule(String teacherId){
    return homeClassDataSource.fetchSchedule(teacherId);
  }
}