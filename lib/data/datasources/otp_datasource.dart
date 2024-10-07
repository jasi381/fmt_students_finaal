import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OtpDataSource {
  Future<String> sendOtp(String phoneNumber) async {
    final otp = Random().nextInt(9000) + 1000;
    if (kDebugMode) {
      print("Data source :$otp");
    }
    final url = Uri.parse('https://bulksmsplans.com/api/send_sms');
    final headers = {'Content-Type': 'application/json'};
    final data = {
      'api_id': 'API4Huyli0f128474',
      'api_password': 'P4TmjtiB',
      'sms_type': 'OTP',
      'sms_encoding': 'text',
      'sender': 'ITSHPL',
      'number': phoneNumber,
      'message':
          'Dear Student, Your OTP is $otp to Login, Do not share it with anyone. INTELLITEACH TECH STUDY HELP PRIVATE LIMITED',
      'template_id': '159803',
    };

    final response =
        await http.post(url, headers: headers, body: json.encode(data));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Repo Otp:$otp");
      }
      return otp.toString();
    } else {
      if (kDebugMode) {
        print("Failure : ${response.body}");
      }
      throw Exception('Failed to send OTP: ${response.body}');
    }
  }
}
