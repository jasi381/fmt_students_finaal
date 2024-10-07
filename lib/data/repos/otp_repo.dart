import 'package:students/data/datasources/otp_datasource.dart';

class OtpRepository {
  final OtpDataSource dataSource;

  OtpRepository(this.dataSource);

  Future<String> sendOtp(String phoneNumber) {
    return dataSource.sendOtp(phoneNumber);
  }
}
