import 'package:students/data/datasources/home_booking_data_source.dart';
import 'package:students/data/models/home_booking_model.dart';
import 'package:students/data/models/response_model.dart';

class HomeBookingRepo {
  final HomeBookingDataSource homeBookingDataSource;

  HomeBookingRepo(this.homeBookingDataSource);

  Future<ResponseModel> bookSession(HomeBookingModel homeBookingModel,ApiType apiType) {
    return homeBookingDataSource.bookHomeClass(homeBookingModel,apiType);
  }
}
