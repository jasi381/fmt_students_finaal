import 'package:students/data/models/home_classes_model.dart';

class HomeClassEntity {
  final bool success;
  final List<DaySchedule> data;

  HomeClassEntity({required this.success, required this.data});

}