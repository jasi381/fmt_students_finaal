import 'package:flutter/foundation.dart';
import 'package:students/data/models/response_model.dart';
import 'package:students/domain/entities/register_entity.dart';
import 'package:students/domain/usecases/register_use_case.dart';

class RegisterProvider extends ChangeNotifier {
  final RegisterUseCase _registerUseCase;
  bool _isLoading = false;
  String? _message;
  String? _error;
  ResponseModel? _response;

  RegisterProvider(this._registerUseCase);

  bool get isLoading => _isLoading;

  String? get message => _message;

  String? get error => _error;

  ResponseModel? get response => _response;

  Future<void> register(RegisterEntity registerEntity) async {
    _isLoading = true;
    _message = null;
    _error = null;
    _response = null;
    notifyListeners();

    try {
      _response = await _registerUseCase(registerEntity);
      _message = 'Register successful';
    } catch (e) {
      _error = e.toString();
      debugPrint("Login error: $_error");
    } finally {
      _isLoading = false;
      debugPrint("Register response: ${_response?.message ?? 'null'}");
      debugPrint("Register message: $_message");
      debugPrint("Register error: $_error");
      notifyListeners();
    }
  }
}