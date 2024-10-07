import 'package:students/data/datasources/home_booking_data_source.dart';
import 'package:students/data/models/home_booking_model.dart';
import 'package:students/data/models/response_model.dart';
import 'package:students/data/repos/home_booking_repo.dart';
import 'package:students/domain/entities/home_booking_entity.dart';

class HomeBookingUseCase {
  final HomeBookingRepo repo;

  HomeBookingUseCase(this.repo);

  Future<ResponseModel> call(HomeBookingEntity homeBookingEntity,ApiType apiType) async {
    final homeBookingModel = HomeBookingModel(
        phone: homeBookingEntity.phone,
        amount: homeBookingEntity.amount,
        classDate: homeBookingEntity.classDate,
        classTime: homeBookingEntity.classTime,
        teacher: homeBookingEntity.teacher

    );

    final responseModel = await repo.bookSession(homeBookingModel,apiType);
    return responseModel;
  }
}
