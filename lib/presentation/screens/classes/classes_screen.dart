import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students/presentation/screens/classes/center_classes.dart';
import 'package:students/presentation/screens/classes/home_classes/home_classes.dart';
import 'package:students/presentation/screens/classes/online_classes.dart';
import 'package:students/presentation/utils/navigate_to.dart';
import 'package:students/utils/constants.dart';


class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Constants.appBarColor,
        elevation: 0,
        title: Text(
          "Explore",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What would you like to do?",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: _buildItems(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context) {
    return [
      _buildItem(
        'Online Class',
        'assets/images/chat_with_teacher.png',
        Colors.blue[100]!,
            () => push(context, const OnlineClassesScreen()),
      ),
      _buildItem(
        'Home Class',
        'assets/images/talk_to_teacher.png',
        Colors.green[100]!,
            () => push(context,const HomeClassesScreen()),
      ),
      _buildItem(
        'Center Class',
        'assets/images/book_class.png',
        Colors.orange[100]!,
            () => push(context,const CenterClassesScreen()),
      ),
    ];
  }


  Widget _buildItem(String title, String imagePath, Color backgroundColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath,fit: BoxFit.contain,height: 110,),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AutoSizeText(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

