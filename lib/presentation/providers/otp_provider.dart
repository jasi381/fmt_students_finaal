import 'package:flutter/widgets.dart';
import 'package:students/domain/usecases/otp_use_case.dart';

class OtpProvider extends ChangeNotifier {
  final SendOtpUseCase _sendOtpUseCase;
  bool _isLoading = false;
  String? _message;
  String? _error;
  String? _otp;

  OtpProvider(this._sendOtpUseCase);

  bool get isLoading => _isLoading;

  String? get message => _message;

  String? get error => _error;

  String? get otp => _otp;

  Future<void> sendOtp(String phoneNumber) async {
    _isLoading = true;
    _message = null;
    _error = null;
    _otp = null;
    notifyListeners();

    try {
      _otp = await _sendOtpUseCase(phoneNumber);
      _message = 'OTP sent successfully';
    } catch (e) {
      _error = 'Error sending OTP: ${e.toString()}'; // Provide more detailed error information
      // Debugging line
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
