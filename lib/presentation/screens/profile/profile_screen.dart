import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';
import 'package:students/presentation/screens/auth/login_screen.dart';
import 'package:students/presentation/screens/profile/edit_profile.dart';
import 'package:students/presentation/screens/profile/privacy_policy.dart';
import 'package:students/presentation/utils/navigate_to.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _setLoginStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', status);
  }

  void _logout() async {
    await _setLoginStatus(false);
    // Navigate back to login screen or splash screen
    if (mounted) {
      pushReplacement(context, const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const PoppinsText(
          text: "My Profile",
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
      ),
      backgroundColor: const Color(0xffececec),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Stack(
                children: [
                  CustomPaint(
                    painter: CurvedBottomRectangle(),
                    size:
                        const Size(double.infinity, 120), // Adjust size as needed
                  ),
                ],
              ),
              // Positioned Stack for the container
              Positioned(
                bottom: -40, // Position it right at the bottom of the screen
                left: MediaQuery.of(context).size.width / 2 -
                    55, // Center horizontally
                child: Stack(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: const BoxDecoration(),
                      child: CachedNetworkImage(
                        imageUrl: "https://i.ibb.co/gMw1RCM/Rectangle-6.png",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    // New container in the bottom right of the image
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          //TODO:
                        },
                        child: Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0x33808080),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            height: 20,
                            width: 20,
                            child: Image.asset("assets/icons/edit.png"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 50), // Add space for the image to overlap
          const RobotoText(
            text: "Puerto Rico",
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const RobotoText(
                text: "youremail@domain.com",
                fontSize: 14,
              ),
              const SizedBox(
                width: 4,
              ),
              Container(
                width: 1,
                color: Colors.black,
                height: 12,
              ),
              const SizedBox(
                width: 4,
              ),
              const RobotoText(
                text: "+01 234 567 89",
                fontSize: 14,
              )
            ],
          ),
          const SizedBox(height: 25),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    push(context, const EditProfileScreen());
                  },
                 splashColor: Colors.transparent,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.asset("assets/icons/edit_profile_info.png"),
                        const SizedBox(
                          width: 10,
                        ),
                        const RobotoText(text: "Edit profile information")
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  height: 1.4,
                  width: double.infinity,
                  color: const Color(0x66808080),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                    child: Row(
                      children: [
                        Image.asset("assets/icons/contacts-line.png"),
                        const SizedBox(
                          width: 10,
                        ),
                        const RobotoText(text: "Help & Support")
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  height: 1.4,
                  width: double.infinity,
                  color: const Color(0x66808080),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                    child: Row(
                      children: [
                        Image.asset("assets/icons/chat-quote-line.png"),
                        const SizedBox(
                          width: 10,
                        ),
                        const RobotoText(text: "Contact us")
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Container(
                  height: 1.4,
                  width: double.infinity,
                  color: const Color(0x66808080),
                ),
                InkWell(
                  onTap: () {
                    push(context, const PrivacyPolicyWebView());
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Image.asset("assets/icons/lock-2-line.png"),
                        const SizedBox(
                          width: 10,
                        ),
                        const RobotoText(text: "Privacy policy")
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xffD9534F),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    size: 28,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  PoppinsText(
                    text: "Logout",
                    fontSize: 22,
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CurvedBottomRectangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - 28)
      ..quadraticBezierTo(size.width / 2, size.height + 28, 0, size.height - 28)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
