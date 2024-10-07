import 'package:students/data/repos/otp_repo.dart';

class SendOtpUseCase {
  final OtpRepository repository;

  SendOtpUseCase(this.repository);

  Future<String> call(String phoneNumber) {
    return repository.sendOtp(phoneNumber);
  }
}
