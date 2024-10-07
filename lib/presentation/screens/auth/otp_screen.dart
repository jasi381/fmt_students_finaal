import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:students/presentation/appComponents/buttonComponent/button_component.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';
import 'package:students/presentation/providers/login_provider.dart';
import 'package:students/presentation/screens/auth/login_screen.dart';
import 'package:students/presentation/screens/auth/register_screen.dart';
import 'package:students/presentation/screens/main_screen.dart';
import 'package:students/presentation/utils/navigate_to.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String otp;

  const OtpVerificationScreen(
      {super.key, required this.phoneNumber, required this.otp});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final SmsRetriever smsRetriever;
  late final LoginProvider _loginProvider;

  // Add this constant for testing
  static const String TEST_PHONE_NUMBER = "1234567890";

  @override
  void initState() {
    super.initState();
    pinController = TextEditingController();
    focusNode = FocusNode();
    smsRetriever = SmsRetrieverImpl(SmartAuth());
    _loginProvider = Provider.of<LoginProvider>(context, listen: false);

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loginProvider.login(widget.phoneNumber));

    if(widget.phoneNumber == TEST_PHONE_NUMBER){
      pinController.text = widget.otp;
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _handleValidPin() {
    if (pinController.text == widget.otp) {
      if (_loginProvider.loginResponse?.message ==
          "Number already Registered.") {
        pushReplacement(context, const MainScreen());
      } else {
        pushReplacement(
            context,
            RegisterScreen(
              phoneNumber: widget.phoneNumber,
            ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    const borderColor = Color(0xffFF8B59);
    const errorColor = Colors.redAccent;
    const fillColor = Color(0xffececec);
    final defaultPinTheme = PinTheme(
      width: 62,
      height: 68,
      textStyle: GoogleFonts.roboto(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        if (context.mounted) {
          pushReplacement(context, const LoginScreen());
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: mediaQuery.padding.top),
              _buildBackButton(),
              const SizedBox(height: 38),
              _buildHeaderText(),
              const SizedBox(height: 40),
              _buildPinput(defaultPinTheme, borderColor, errorColor),
              const SizedBox(height: 40),
              _buildVerifyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(8),
      child: GestureDetector(
        onTap: () => pushReplacement(context, const LoginScreen()),
        child: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: const Color(0xffedeef2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Icon(CupertinoIcons.back, color: Colors.black, size: 25),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PoppinsText(
            text: "OTP Verification",
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 8),
          RobotoText(
            text:
                "Enter the verification code we just sent on your phone number.",
            fontSize: 18,
            maxLines: 2,
            textColor: Color(0xff4B5768),
          ),
        ],
      ),
    );
  }

  Widget _buildPinput(
      PinTheme defaultPinTheme, Color borderColor, Color errorColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Pinput(
        showCursor: true,
        smsRetriever: smsRetriever,
        controller: pinController,
        focusNode: focusNode,
        defaultPinTheme: defaultPinTheme,
        separatorBuilder: (index) => const SizedBox(width: 14),
        validator: (value) => value == widget.otp ? null : 'Invalid OTP',
        hapticFeedbackType: HapticFeedbackType.mediumImpact,
        onCompleted: (pin) {
          _handleValidPin();
        },
        onChanged: (value) => debugPrint('onChanged: $value'),
        focusedPinTheme: defaultPinTheme.copyWith(
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: borderColor, width: 2),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyBorderWith(
          border: Border.all(color: errorColor, width: 2),
        ),
        enabled: widget.phoneNumber != TEST_PHONE_NUMBER,
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ButtonComponent(
        text: "Verify",
        fontSize: 17,
        fontWeight: FontWeight.w500,
        textColor: Colors.white,
        onPressed: () {
          _handleValidPin();
        },
      ),
    );
  }
}

class SmsRetrieverImpl implements SmsRetriever {
  const SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() {
    return smartAuth.removeSmsListener();
  }

  @override
  Future<String?> getSmsCode() async {
    final signature = await smartAuth.getAppSignature();
    debugPrint('App Signature: $signature');
    final res = await smartAuth.getSmsCode(
      useUserConsentApi: true,
    );
    if (res.succeed && res.codeFound) {
      return res.code!;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}
