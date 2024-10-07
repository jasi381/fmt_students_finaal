import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:students/presentation/appComponents/teacher_card/call_teacher_card.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';
import 'package:students/presentation/screens/call/teacher_details.dart';
import 'package:students/presentation/utils/navigate_to.dart';
import 'package:students/presentation/utils/subjects_teachers.dart';
import 'package:students/utils/constants.dart';

class SubjectTeachersScreen extends StatefulWidget {
  final String subject;

  const SubjectTeachersScreen({super.key, required this.subject});

  @override
  State<SubjectTeachersScreen> createState() => _SubjectTeachersScreenState();
}

class _SubjectTeachersScreenState extends State<SubjectTeachersScreen> {
  late Future<List<Teacher>> _teacherList;

  @override
  void initState() {
    super.initState();
    _teacherList = TeacherService().fetchTeachers(widget.subject);
  }

  void _navigateToTeacherDetails(BuildContext context, Teacher teacher,) {
    if (teacher.id != null) {
      push(
          context,
          TeacherDetailsScreen(
            teacherId: teacher.id??"",
            photo: teacher.photo ?? "",
            teacherName: teacher.name??"",
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffececec),
      appBar: AppBar(
        title: const PoppinsText(text: 'Teachers',fontSize: 22,fontWeight: FontWeight.w500,textColor: Colors.white,),
        backgroundColor: Constants.appBarColor,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
            icon:Icon(Platform.isIOS? CupertinoIcons.back:Icons.arrow_back,color: Colors.white,)
        ),
      ),
      body: FutureBuilder<List<Teacher>>(
        future: _teacherList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Teacher>? teachers = snapshot.data;

            // Check if the teacher list is empty
            if (teachers == null || teachers.isEmpty) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 22.0,
                          color: Colors.black87,
                          fontFamily: 'Roboto',
                        ),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            TypewriterAnimatedText('Currently there are no teachers of the selected subject'),
                            TypewriterAnimatedText('We are looking for them and will update you soon'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                Teacher teacher = teachers[index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: MainTeacherCard(
                    onTap: () => _navigateToTeacherDetails(context, teacher),
                    education: teacher.education ?? "",
                    isVerified: false,
                    location: teacher.location ?? "",
                    name: teacher.name ?? "",
                    photo: teacher.photo ?? "",
                    sessionPrice: teacher.voice ?? "10",
                    subject: teacher.subject ?? "",
                    userName: teacher.username ?? "",
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No teachers found'));
          }
        },
      ),
    );
  }
}

