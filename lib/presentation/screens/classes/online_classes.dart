import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:students/presentation/appComponents/teacher_card/call_teacher_card.dart';
import 'package:students/presentation/screens/classes/home_classes/home_teacher_details.dart';
import 'package:students/presentation/utils/navigate_to.dart';
import 'package:students/utils/constants.dart';
import '../../../data/datasources/home_booking_data_source.dart';

class OnlineClassesScreen extends StatefulWidget {
  const OnlineClassesScreen({super.key});

  @override
  OnlineClassesScreenState createState() => OnlineClassesScreenState();
}

class OnlineClassesScreenState extends State<OnlineClassesScreen> {
  List<Map<String, dynamic>> tutors = [];

  @override
  void initState() {
    super.initState();
    fetchTutors();
  }

  Future<void> fetchTutors() async {
    final response = await http.get(Uri.parse(
        'https://findmytuition.com/api/talkteacher.php?API-Key=58dc7c68-cd25-4fd9-b812-ded375ab7a3f&classtype=online&phone=9123353923'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['success'] == true) {
        setState(() {
          tutors = List<Map<String, dynamic>>.from(jsonData['data']);
        });
      }
    } else {
      throw Exception('Failed to load tutors');
    }
  }

  void _navigateToTeacherDetails(BuildContext context, Map<String, dynamic> tutor) {
    if (tutor['id'] != null) {
      push(context, HomeTeacherDetails(
        teacherId: tutor['id'],
        photo: tutor['photo'] ?? "",
        teacherName: tutor['name'] ?? "",
        sessionPrice: tutor['online_price'] ?? "10",
        apiType: ApiType.online,
      ));
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
          "Book a online class",
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
      ),
      body: tutors.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: tutors.length,
        itemBuilder: (context, index) {
          var tutor = tutors[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: MainTeacherCard(
              onTap: () => _navigateToTeacherDetails(context, tutor),
              education: tutor['education'] ?? "",
              isVerified: tutor['verified'] == "1",
              location: tutor['location'] ?? "",
              name: tutor['name'] ?? "",
              photo: tutor['photo'] ?? "",
              sessionPrice: tutor['online_price'] ?? "10",
              subject: tutor['subject'] ?? "",
              userName: tutor['username'] ?? "",
            ),
          );
        },
      ),
    );
  }
}


