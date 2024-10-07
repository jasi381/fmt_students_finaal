import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:students/presentation/utils/check_bal.dart';
import 'package:students/utils/constants.dart';

class RedeemCoinsScreen extends StatefulWidget {
  const RedeemCoinsScreen({super.key});

  @override
  RedeemCoinsScreenState createState() => RedeemCoinsScreenState();
}

class RedeemCoinsScreenState extends State<RedeemCoinsScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _coinController = TextEditingController();
  double _price = 0.0;
  bool _isAmountValid = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String keyId = 'rzp_live_AqAs5xu9kzSoa1';
  String secretId = '75WF2xGtM9oMW03STUOKEGIK';
  late Razorpay razorpay;
  bool _isProcessingPayment = false;

  @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _coinController.dispose();
    razorpay.clear();
    super.dispose();
  }

  void _calculatePrice() {
    setState(() {
      int coins = int.tryParse(_coinController.text) ?? 0;
      _price = coins * 1;
      _isAmountValid = _price >= 50;
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Recharge Wallet', style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon:  Icon(Platform.isIOS? Icons.arrow_back_ios:Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/redeem.png",
                  height: 170,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 8),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    'How much money do want to add?',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 8,),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    '(Min amount :₹50)',
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: TextField(
                    controller: _coinController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: '',
                      prefixIcon: const Icon(Icons.monetization_on, color: Colors.black26),
                    ),
                    onChanged: (_) => _calculatePrice(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                      child: Text(
                        'Amount to pay: ₹ ${_price.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isAmountValid
                              ? () async {
                            var amountInPaise = _price*100;
                            await openCheckout(amountInPaise);
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isAmountValid ? Constants.appBarColor : Colors.grey[300],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: _isAmountValid ? 8 : 0,
                            shadowColor: _isAmountValid ? Colors.blue[300] : Colors.transparent,
                          ),
                          child: Text(
                            "Buy Coins",
                            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {

    if (!_isProcessingPayment) return;

    Fluttertoast.showToast(msg: "Payment Successful");
    try {
      await WalletService.rechargeWallet(_price.toStringAsFixed(2), response.paymentId.toString());
      Fluttertoast.showToast(msg: "Payment Successful");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error occurred while processing payment");
    } finally {
      setState(() {
        _isProcessingPayment = false;
      });
    }
    }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed");
    debugPrint("Payment Failed: ${response.error}");
    setState(() {
      _isProcessingPayment = false;
    });
  }

  Future<String> createRazorpayOrder(double amountInPaise) async {
    const String apiUrl = 'https://api.razorpay.com/v1/orders';


    final String basicAuth = 'Basic ${base64Encode(utf8.encode('$keyId:$secretId'))}';

    final Map<String, dynamic> requestBody = {
      "amount": amountInPaise.round(),
      "currency": "INR",
      "receipt": "order_rcptid_${DateTime.now().millisecondsSinceEpoch}",
      "notes": {
        "description": "Order description"
      }
    };


    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'content-type': 'application/json',
          'Authorization': basicAuth,
        },
        body: jsonEncode(requestBody),
      );


      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['id'];
      } else {
        throw Exception('Failed to create Razorpay order: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> openCheckout(double amountInPaise) async {

    if (_isProcessingPayment) return;

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      String orderId = await createRazorpayOrder(amountInPaise);
      String? phoneNumber = await WalletService.getPhoneNumber();
      var options = {
        'key': keyId,
        'amount': amountInPaise,
        'name': 'Find my Tution',
        'order_id': orderId,
        'description': 'Coin Purchase',
        'prefill': {'contact': phoneNumber },
        'external': {
          'wallets': ['paytm']
        }
      };
      razorpay.open(options);
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to open checkout: $e");
    }
  }
}



