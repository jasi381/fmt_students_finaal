import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';
import 'package:students/presentation/utils/check_bal.dart';
import 'package:students/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseDetails extends StatefulWidget {
  final String courseId;


  const CourseDetails({super.key, required this.courseId});

  @override
  CourseDetailsState createState() => CourseDetailsState();
}

class CourseDetailsState extends State<CourseDetails> {
  Map<String, dynamic>? courseData;
  bool isLoading = true;
  String? studentId;
  bool isPurchasing = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchCourseDetails();
  }

  Future<void> fetchCourseDetails() async {
    studentId = await WalletService.getPhoneNumber();
    final url = '${Constants.baseUrl}coursedetails.php?API-Key=58dc7c68-cd25-4fd9-b812-ded375ab7a3f&courseid=${widget.courseId}&studentid=$studentId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true && jsonData['coursedetails'].isNotEmpty) {
          setState(() {
            courseData = jsonData['coursedetails'][0];
            isLoading = false;
          });
        } else {
          setState(() {
            error = "Failed to load course details";
          });
          throw Exception('Failed to load course details');
        }
      } else {
        setState(() {
          error = "Failed to load course details";
        });
        throw Exception('Failed to load course details');
      }
    } catch (e) {
      setState(() {
        error = "Failed to load course details";
      });
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 0), // Reduce left padding of title
          child: PoppinsText(
            text: courseData?['title']??"",
            textColor: Colors.white,
            fontSize: 22,
            maxLines: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
        leadingWidth: 40, // Reduce the width of the leading icon area
        toolbarHeight: 60,
        backgroundColor: Constants.appBarColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero, // Remove padding from IconButton
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : courseData == null
          ? const Center(child: Text('Failed to load course details'))

          :error== null? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(
                courseData!['imageUrl'] ?? '',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  height: 200,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 50, color: Colors.red),
                        SizedBox(height: 10),
                        Text('Failed to load image', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseData!['title'] ?? 'No Title',
                    style: GoogleFonts.poppins(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(courseData!['subcategory'] ?? 'No Subcategory',
                      style: GoogleFonts.roboto(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('5.0', style: GoogleFonts.roboto(color: Colors.black, fontSize: 16)),
                      const SizedBox(width: 4),
                      ...List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 17)),
                      const SizedBox(width: 4),
                      Text('(${courseData!['ratings']?.length ?? 0} ratings)',
                          style: GoogleFonts.roboto(color: Colors.black, fontSize: 14)),
                    ],
                  ),
                  Text('Skill Level: ${courseData!['skill_level'] ?? 'Not specified'}',
                      style: GoogleFonts.roboto(color: Colors.black, fontSize: 15)),
                  const SizedBox(height: 8),
                  Text('Category: ${courseData!['category'] ?? 'Not specified'}',
                      style: GoogleFonts.roboto(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 16),
                  Text('₹${courseData!['price'] ?? 'Price not available'}',
                      style: GoogleFonts.roboto(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                !(courseData?['purchased'])?
                ElevatedButton(
                  onPressed: isPurchasing
                      ? null
                      : () async {
                    setState(() {
                      isPurchasing = true;
                    });
                    await fetchCourseData(context);
                    setState(() {
                      isPurchasing = false;
                    });
                    fetchCourseDetails();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.appBarColor,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: isPurchasing
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.0,
                    ),
                  )
                      : Text(
                    'Buy now',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                )
                    : ElevatedButton(
                  onPressed: null, // Disables the button
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Disabled button color
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Course Already Purchased',
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 16),
                  Text('Course Overview',
                      style: GoogleFonts.poppins(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(courseData!['overview'] ?? 'No overview available',
                      style: GoogleFonts.roboto(color: Colors.black, fontSize: 16)),
                  const SizedBox(height: 16),
                  Text('Course Curriculum',
                      style: GoogleFonts.poppins(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Html(
                    data: courseData!['curriculum'] ?? 'No curriculum available',
                    style: {
                      "body": Style(
                        fontSize: FontSize(16),
                        fontFamily: 'Roboto',
                      ),
                      "h4": Style(
                        fontSize: FontSize(18),
                        fontWeight: FontWeight.bold,
                      ),
                      "ul": Style(
                      ),
                      "li": Style(

                      ),
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom,)
          ],
        ),
      ) :const Center(child: Text('Failed to load course details'))
    );
  }

  Future<void> fetchCourseData(BuildContext context) async {
    final phone = await WalletService.getPhoneNumber();
    const url = '${Constants.baseUrl}courseschedule.php?API-Key=${Constants.apiKey}';

    try {
      // Check if balance is sufficient before proceeding
      double coursePrice = double.parse(courseData!['price'] ?? '0');
      bool isBalanceEnough = await WalletService.isBalanceSufficient(coursePrice);

      if (!isBalanceEnough) {
        showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Insufficient Balance'),
              content: const Text('You do not have enough balance to proceed with this action.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phone,
          'courseid': widget.courseId,
        }),
      );

      if (response.statusCode == 200) {
        // Handle success
        jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course Purchased Successfully')),
        );
      } else {
        // Handle error
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Unable to fetch course data or process purchase')),
      );
    }
  }

}