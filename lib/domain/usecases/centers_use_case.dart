import 'package:students/data/repos/centers_repo.dart';
import 'package:students/domain/entities/tutor_entity.dart';

class CentersUseCase {
  final CentersRepo repo;

  CentersUseCase(this.repo);

  Future<List<TutorEntity>> call(
      String phoneNumber,
      double lat,
      double long
      ) async {
    final tutorModels = await repo.fetchCenters(phoneNumber, lat, long);

    // Ensure tutorModels is a List<Tutor>
    print("Tutor Models Length: ${tutorModels.length}");

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
        best: model.best,
        homePrice: model.homePrice
    )).toList();
  }
}
