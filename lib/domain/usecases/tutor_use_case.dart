import 'package:students/data/datasources/tutor_data_source.dart';
import 'package:students/data/repos/tutor_repo.dart';
import 'package:students/domain/entities/tutor_entity.dart';

class TutorUseCase {
  final TutorRepo repo;

  TutorUseCase(this.repo);

  Future<List<TutorEntity>> call(ApiType type,{String? phoneNumber}) async {
    final tutorModels = await repo.fetchTutors(type,phoneNumber: phoneNumber);

    return tutorModels.map((model) => TutorEntity(
        name: model.name,
        education: model.education,
        location: model.location,
        photo: model.photo,
        voice: model.voice,
        video: model.video,
        subject: model.subject,
        username: model.username,
        verified: model.verified,
        id: model.id,
        best:  model.best,
      homePrice: model.homePrice
    )).toList();
  }
}
