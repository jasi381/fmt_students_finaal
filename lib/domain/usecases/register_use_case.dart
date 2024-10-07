import 'package:students/data/models/register_model.dart';
import 'package:students/data/models/response_model.dart';
import 'package:students/data/repos/register_repo.dart';
import 'package:students/domain/entities/register_entity.dart';

class RegisterUseCase {
  final RegisterRepo repo;

  RegisterUseCase(this.repo);

  Future<ResponseModel> call(RegisterEntity registerEntity) async {
    final registerModel = RegisterModel(
     name: registerEntity.name,
      email:  registerEntity.email,
      address: registerEntity.address,
      course: registerEntity.course,
      state: registerEntity.state,
      city: registerEntity.city,
      pin_code: registerEntity.pin_code,
      phone: registerEntity.phone

    );

    final responseModel = await repo.register(registerModel);

    return responseModel;
  }
}
