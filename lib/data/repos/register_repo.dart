import 'package:students/data/datasources/register_data_source.dart';
import 'package:students/data/models/register_model.dart';
import 'package:students/data/models/response_model.dart';

class RegisterRepo {
  final RegisterDatasource registerDatasource;

  RegisterRepo(this.registerDatasource);

  Future<ResponseModel> register(RegisterModel registerModel) {
    return registerDatasource.register(registerModel);
  }
}
