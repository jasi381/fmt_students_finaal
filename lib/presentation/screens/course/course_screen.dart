import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:students/data/models/courses_model.dart';
import 'package:students/presentation/providers/course_provider.dart';
import 'package:students/presentation/screens/course/course_details.dart';
import 'package:students/presentation/utils/navigate_to.dart';
import 'package:students/utils/constants.dart';


class ImprovedCourseListView extends StatelessWidget {
  const ImprovedCourseListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffececec),
      appBar:  AppBar(
        toolbarHeight: 60,
        backgroundColor: Constants.appBarColor,
        elevation: 0,
        title: Text(
          "Courses",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Constants.appBarColor,
      //   onPressed: (){
      //
      //     showMaterialModalBottomSheet(
      //       context: context,
      //       builder: (context) => const FilterBottomSheet(),
      //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //       animationCurve: Curves.linear
      //     );
      //   },
      //   child: const Icon(Icons.filter_alt_outlined,color: Colors.white,size: 32,
      //   ),
      // ),
      body: Consumer<CourseProvider>(
        builder: (context,provider,child){
          final courses = provider.courses;
          if(courses!.courses.isEmpty){
            return const Center(child: Text('No best tutors available.'));
          }
          else{
           return  ListView.builder(
              itemCount: courses.courses.length,
              itemBuilder: (context, index) => CourseCard(course: courses.courses[index]),
            );
          }
        },
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final CourseItem course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: InkWell(
        onTap: (){
        push(context, CourseDetails(courseId:course.id));
        },
        radius: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageWithBuyButton(context),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(context),
                  const SizedBox(height: 8),
                  _buildDescription(context),
                  const SizedBox(height: 16),
                  _buildPriceAndBuyButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildImageWithBuyButton(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: CachedNetworkImage(
              imageUrl: course.imageUrl,
              fit: BoxFit.cover,
              placeholder:(context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildTitleRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            course.title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        const AnimatedJobAssistance(),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      course.description,
      style: GoogleFonts.roboto(
        fontSize: 17,
        fontWeight: FontWeight.w400
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceAndBuyButton(BuildContext context) {
    return Row(
      children: [
        Text(
          // Assuming course.price is a string
          '₹${double.parse(course.price).toStringAsFixed(0)}/-',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xff2E7D32),
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: const Offset(2.0, 2.0), // Shadow position
                blurRadius: 3.0, // Shadow blur radius
                color: Colors.black.withOpacity(0.1), // Shadow color with opacity
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnimatedJobAssistance extends StatefulWidget {
  const AnimatedJobAssistance({super.key});

  @override
  AnimatedJobAssistanceState createState() => AnimatedJobAssistanceState();
}

class AnimatedJobAssistanceState extends State<AnimatedJobAssistance> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Text(
          'With Job Assistance',
          style: GoogleFonts.poppins(
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
