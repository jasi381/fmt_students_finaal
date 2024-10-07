import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:students/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletService {
  static Future<String?> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phone_number');
  }

  static Future<String?> fetchWalletBalance() async {
    String? phoneNumber = await getPhoneNumber();

    if (phoneNumber == null) {
      throw Exception('Phone number not found');
    }

    String url = '${Constants.baseUrl}walletbalance.php?API-Key=${Constants.apiKey}&phone=$phoneNumber';

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success']) {
        return jsonResponse['walletbalance'];
      } else {
        throw Exception('Failed to fetch wallet balance: success flag false');
      }
    } else {
      throw Exception('Failed to load wallet balance');
    }
  }

  static Future<bool> isBalanceSufficient(double sessionPrice) async {
    String? balanceString = await fetchWalletBalance();

    if (balanceString == null) {
      throw Exception('Could not fetch wallet balance');
    }

    double balance;
    try {
      balance = double.parse(balanceString);
    } catch (e) {
      throw Exception('Failed to parse wallet balance');
    }

    return balance >= sessionPrice;
  }

  static Future<void> rechargeWallet(String amount, String paymentId) async {
    String? phoneNumber = await getPhoneNumber();

    if (phoneNumber == null) {
      throw Exception('Phone number not found');
    }

    String url = '${Constants.baseUrl}walletrecharge.php?API-Key=${Constants.apiKey}';

    final body = jsonEncode({
      'phone': phoneNumber,
      'amount': amount,
      'paymentid': paymentId,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (!jsonResponse['success']) {
        throw Exception('Failed to recharge wallet: ${jsonResponse['message']}');
      }
    } else {
      throw Exception('Failed to recharge wallet');
    }
  }
}

