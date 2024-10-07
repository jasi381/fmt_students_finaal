import 'package:students/data/datasources/tutor_data_source.dart';
import 'package:students/data/models/tutor_model.dart';

class TutorRepo {

  final TutorDataSource tutorDataSource;

  TutorRepo(this.tutorDataSource);

  Future<List<Tutor>> fetchTutors(ApiType type,{String? phoneNumber}) {
    return tutorDataSource.fetchTutors(type,phoneNumber: phoneNumber);
  }
}
