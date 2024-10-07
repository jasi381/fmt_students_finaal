import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:students/data/datasources/center_data_source.dart';
import 'package:students/data/datasources/home_booking_data_source.dart';
import 'package:students/data/repos/centers_repo.dart';
import 'package:students/domain/entities/tutor_entity.dart';
import 'package:students/domain/usecases/centers_use_case.dart';
import 'package:students/presentation/appComponents/teacher_card/call_teacher_card.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';
import 'package:students/presentation/providers/centers_provider.dart';
import 'package:students/presentation/screens/classes/home_classes/home_teacher_details.dart';
import 'package:students/presentation/utils/navigate_to.dart';
import 'package:students/presentation/utils/shared_pref_helper.dart';
import 'package:students/utils/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class CenterClassesScreen extends StatelessWidget {
  const CenterClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CenterClassesScreen2();
  }
}



class CenterClassesScreen2 extends StatefulWidget {
  const CenterClassesScreen2({super.key});

  @override
  State<CenterClassesScreen2> createState() => _CenterClassesScreen2State();
}



class _CenterClassesScreen2State extends State<CenterClassesScreen2> {
  Position? _currentPosition;
  bool _isLocationFetched = false;
  bool _isLoading = false;
  String _locationMessage = 'Tap the button to get location';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _locationMessage = 'Getting location...';
    });

    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (kDebugMode) {
        print("CenterClassesScreen2 - Location service enabled: $serviceEnabled");
      }
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _locationMessage = 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
        _isLocationFetched = true;

      });
    } catch (e) {
      setState(() => _locationMessage = 'Error: ${e.toString()}');
      _showPermissionDialog();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
            'This app needs location permission to function properly. '
                'Please grant location permission in your device settings.'
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              Navigator.of(context).pop();
              Geolocator.openAppSettings();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _initializeProvider(CentersProvider provider) async {

    try {
      // Fetch phone number from SharedPreferences
      String? phoneNumber = await SharedPreferencesHelper.getPhoneNumber();

      // Ensure phone number and coordinates are available
      if (phoneNumber != null && _currentPosition != null) {

        await provider.fetchCenters(
            phoneNumber,
            _currentPosition!.latitude,
            _currentPosition!.longitude
        );

      } else{
      }
    } catch (error) {
      debugPrint("Something went wrong:$error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffececec),
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Constants.appBarColor,
        elevation: 0,
        title: Text(
          "Book a class",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Platform.isAndroid ? Icons.arrow_back : CupertinoIcons.back),
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showAlertDialog(context);
            },
            icon: const Icon(Icons.info_outline,color: Colors.white),
          ),
        ],
      ),
      body: _isLocationFetched
          ? ChangeNotifierProvider(
        create: (context) {
          final centerDataSource = CenterDataSource();
          final centersRepo = CentersRepo(centerDataSource);
          final centerUseCase = CentersUseCase(centersRepo);
          final provider = CentersProvider(centerUseCase);

          // Initialize the provider with the fetched coordinates
          _initializeProvider(provider);

          return provider;
        },
        child: const CenterClasses(),
      )
          : Center(
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Searching for centers near you...',
              textStyle: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 100),
            ),
            TypewriterAnimatedText(
              'Finding the best options...',
              textStyle: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 100),
            ),
            TypewriterAnimatedText(
              'Hang tight! Loading...',
              textStyle: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1, // You can repeat it or set to infinite
          pause: const Duration(milliseconds: 1000),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
        ),
      ),
    );
  }


  void showAlertDialog(BuildContext context) {
    Widget continueButton = TextButton(
      child: const PoppinsText(text: "Close", fontSize: 18, fontWeight: FontWeight.w500),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const PoppinsText(text: "Your current Location", fontWeight: FontWeight.w500, fontSize: 22),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const PoppinsText(text: "Latitude:", fontSize: 17, fontWeight: FontWeight.w400),
              const SizedBox(width: 4),
              RobotoText(text: _currentPosition!.latitude.toString(), fontSize: 16, fontWeight: FontWeight.w300),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const PoppinsText(text: "Longitude:", fontSize: 17, fontWeight: FontWeight.w400),
              const SizedBox(width: 4),
              RobotoText(text: _currentPosition!.longitude.toString(), fontSize: 16, fontWeight: FontWeight.w300),
            ],
          ),
        ],
      ),
      actions: [continueButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}





class CenterClasses extends StatefulWidget {
  const CenterClasses({super.key});

  @override
  State<CenterClasses> createState() => _CenterClassesState();
}

class _CenterClassesState extends State<CenterClasses> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  void _navigateToTeacherDetails(BuildContext context, TutorEntity tutor) {
    if (tutor.id != null) {
      push(context, HomeTeacherDetails(
        teacherId: tutor.id??"",
        photo: tutor.photo ?? "",
        teacherName: tutor.name??"",
        sessionPrice :tutor.homePrice??"",
        apiType: ApiType.center,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<CentersProvider>(
      builder: (context, tutorProvider, child) {

        if (tutorProvider.centers.isEmpty) {
          return const Center(child: Text("No Centers found near your location"));
        }

        return ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: tutorProvider.centers.length,
          itemBuilder: (context, index) {
              final tutor = tutorProvider.centers[index];

              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: MainTeacherCard(
                  onTap: () => _navigateToTeacherDetails(context, tutor),
                  education: tutor.education ?? "",
                  isVerified: tutor.verified == "1",
                  location: tutor.location ?? "",
                  name: tutor.name ?? "",
                  photo: tutor.photo ?? "",
                  sessionPrice: tutor.homePrice ?? "10",
                  subject: tutor.subject ?? "",
                  userName: tutor.username ?? "",
                  showPrice: false,
                ),
              );
          },
        );
      },
    );
  }


}
