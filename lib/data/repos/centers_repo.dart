import 'package:students/data/datasources/center_data_source.dart';
import 'package:students/data/models/tutor_model.dart';

class CentersRepo {

  final CenterDataSource centerDataSource;

  CentersRepo(this.centerDataSource);

  Future<List<Tutor>> fetchCenters(
      String phoneNumber,
      double lat,
      double long
      ) {

    return centerDataSource.fetchCenters(phoneNumber, lat, long);
  }
}