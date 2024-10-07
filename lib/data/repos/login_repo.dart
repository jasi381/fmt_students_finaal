import 'package:students/data/datasources/login_data_source.dart';
import 'package:students/data/models/login_model.dart';
import 'package:students/data/models/response_model.dart';

class LoginRepo {
  final LoginDatasource loginDatasource;

  LoginRepo(this.loginDatasource);

  Future<ResponseModel> login(LoginModel loginModel) {
    return loginDatasource.login(loginModel);
  }
}
