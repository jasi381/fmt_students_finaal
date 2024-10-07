import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:students/data/datasources/tutor_data_source.dart';
import 'package:students/presentation/providers/course_provider.dart';
import 'package:students/presentation/providers/home_provider.dart';
import 'package:students/presentation/providers/tutor_provider.dart';
import 'package:students/presentation/screens/auth/login_screen.dart';
import 'package:students/presentation/screens/main_screen.dart';
import 'package:students/presentation/utils/navigate_to.dart';
import 'package:students/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1, milliseconds: 400),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
      Provider.of<TutorProvider>(context, listen: false).fetchAllTutors(ApiType.talk);
      Provider.of<HomeProvider>(context, listen: false).loadSubjects();
      Provider.of<HomeProvider>(context, listen: false).loadBlogs();
      Provider.of<HomeProvider>(context, listen: false).loadTopInstitutes();
      Provider.of<CourseProvider>(context, listen: false).loadCourses();

    });

  }

  void _startAnimation() {
    _controller.forward().whenComplete(() {
      setState(() {
      });
      _checkLoginStatus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Ensure the splash screen is displayed for at least 2 seconds
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      if (isLoggedIn) {
        pushReplacement(context, const MainScreen());
      } else {
        pushReplacement(context, const LoginScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Constants.appBarColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/images/logo.png',
                width: 180,
                height: 180,
                scale: 2,
                filterQuality: FilterQuality.high,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
