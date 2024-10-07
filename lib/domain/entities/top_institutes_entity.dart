import 'package:students/data/models/top_institutes_model.dart';

class TopInstitutesEntity {
  final bool success;
  final List<Institution> institutes;

  TopInstitutesEntity({
    required this.success,
    required this.institutes,
  });

}
