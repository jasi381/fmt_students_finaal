import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:students/domain/usecases/otp_use_case.dart';
import 'package:students/presentation/appComponents/buttonComponent/button_component.dart';
import 'package:students/presentation/appComponents/loadingDialog.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';
import 'package:students/presentation/appComponents/textfields/input_text_fields.dart';
import 'package:students/presentation/providers/otp_provider.dart';
import 'package:students/presentation/screens/auth/otp_screen.dart';
import 'package:students/presentation/utils/navigate_to.dart';
import 'package:students/presentation/utils/shared_pref_helper.dart';
import 'package:students/presentation/utils/show_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();


  static const String TEST_PHONE_NUMBER = "1234567890";
  static const String TEST_OTP = "123456";

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void navigateToOtpVerification(
      BuildContext context, String phoneNumber, otp) {
    pushAndRemoveUtil(context,
        OtpVerificationScreen(phoneNumber: phoneNumber, otp: otp));
  }

  Future<void> _handleGetOtp(OtpProvider provider) async {
    final phoneNumber = _phoneController.text;
    // Check if this prints
    if (_isValidPhoneNumber(phoneNumber)) {
      // Check if this prints
      FocusScope.of(context).unfocus();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const LoadingDialog();
        },
      );

      try {
        // Check if this prints
        String otp;
        if(phoneNumber == TEST_PHONE_NUMBER){
          otp = TEST_OTP;
        }else{
          await provider.sendOtp(phoneNumber);
          otp = provider.otp ?? "";
        }

        if (otp.isNotEmpty) {
          await SharedPreferencesHelper.setPhoneNumber(phoneNumber);
          if (!mounted) return;
          Navigator.of(context).pop(); // Close the loading dialog
          _phoneController.clear();
          navigateToOtpVerification(context, phoneNumber, otp);
        } else {
          if (mounted) {
            Navigator.of(context).pop(); // Close the loading dialog
            showSnackBar("Failed to send OTP. Please try again.", context);
          }
        }
      } catch (e) {
        // Check if this prints
        if (mounted) {
          Navigator.of(context).pop(); // Close the loading dialog
          showSnackBar("Failed to send OTP. Please try again.", context);
        }
      }
    } else {
      // Check if this prints
      if (mounted) {
        showSnackBar('Invalid phone number. Please try again.', context);
      }
    }
  }




  bool _isValidPhoneNumber(String phoneNumber) {
    return phoneNumber.length == 10 && int.tryParse(phoneNumber) != null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OtpProvider(context.read<SendOtpUseCase>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 25),
                  Center(child: Image.asset("assets/images/icon.png")),
                  const SizedBox(height: 40),
                  const PoppinsText(
                    text: 'Login',
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  const RobotoText(
                    text: 'Please enter your phone number',
                    textColor: Color(0xff4B5768),
                    fontSize: 18,
                  ),
                  const SizedBox(height: 30),
                  const RobotoText(
                    text: 'Phone number',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 2),
                  InputTextFieldComponent(
                    controller: _phoneController,
                    hint: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    onEditingComplete: () async {
                      final provider =
                          Provider.of<OtpProvider>(context, listen: false);
                      await _handleGetOtp(provider);
                    },
                  ),
                  const SizedBox(height: 50),
                  Consumer<OtpProvider>(
                    builder: (context, provider, child) {
                      return ButtonComponent(
                        text: "Get OTP",
                        onPressed: () async {
                          await _handleGetOtp(provider);
                        },
                        fontSize: 18,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
