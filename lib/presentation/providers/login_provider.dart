import 'package:flutter/foundation.dart';
import 'package:students/data/models/response_model.dart';
import 'package:students/domain/entities/login_entity.dart';
import 'package:students/domain/usecases/login_use_case.dart';

class LoginProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  bool _isLoading = false;
  String? _message;
  String? _error;
  ResponseModel? _loginResponse;

  LoginProvider(this._loginUseCase);

  bool get isLoading => _isLoading;

  String? get message => _message;

  String? get error => _error;

  ResponseModel? get loginResponse => _loginResponse;

  Future<void> login(String phone) async {
    _isLoading = true;
    _message = null;
    _error = null;
    _loginResponse = null;
    notifyListeners();

    try {
      final loginEntity = LoginEntity(phone);
      _loginResponse = await _loginUseCase(loginEntity);
      _message = 'Login successful';
    } catch (e) {
      _error = e.toString();
      debugPrint("Login error: $_error");
    } finally {
      _isLoading = false;
      debugPrint("Login response: ${_loginResponse?.message ?? 'null'}");
      debugPrint("Login message: $_message");
      debugPrint("Login error: $_error");
      notifyListeners();
    }
  }
}
