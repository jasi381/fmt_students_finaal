import 'package:students/data/models/login_model.dart';
import 'package:students/data/models/response_model.dart';
import 'package:students/data/repos/login_repo.dart';
import 'package:students/domain/entities/login_entity.dart';

class LoginUseCase {
  final LoginRepo repo;

  LoginUseCase(this.repo);

  Future<ResponseModel> call(LoginEntity loginEntity) async {
    final loginModel = LoginModel(phone: loginEntity.phone);

    final responseModel = await repo.login(loginModel);

    return responseModel;
  }
}
