import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:students/data/datasources/tutor_data_source.dart';
import 'package:students/data/datasources/home_booking_data_source.dart' as type;
import 'package:students/data/repos/tutor_repo.dart';
import 'package:students/domain/entities/tutor_entity.dart';
import 'package:students/domain/usecases/tutor_use_case.dart';
import 'package:students/presentation/appComponents/teacher_card/call_teacher_card.dart';
import 'package:students/presentation/providers/tutor_provider.dart';
import 'package:students/presentation/screens/classes/home_classes/home_teacher_details.dart';
import 'package:students/presentation/utils/navigate_to.dart';
import 'package:students/presentation/utils/shared_pref_helper.dart';
import 'package:students/utils/constants.dart';

class HomeClassesScreen extends StatelessWidget {
  const HomeClassesScreen({super.key});

  Future<void> _initializeProvider(TutorProvider provider) async {
    try {
      // Fetch phone number from SharedPreferences
      String? phoneNumber = await SharedPreferencesHelper.getPhoneNumber();

      await provider.fetchAllTutors(ApiType.home, phoneNumber: phoneNumber);
    } catch (error) {
      debugPrint("Failed to fetch tutors: $error");
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
      ),
      body: ChangeNotifierProvider(
        create: (context) {
          final tutorDataSource = TutorDataSource(); // Ensure this is initialized properly
          final tutorRepo = TutorRepo(tutorDataSource);
          final tutorUseCase = TutorUseCase(tutorRepo);
          final provider = TutorProvider(tutorUseCase);

          // Initialize the provider asynchronously
          _initializeProvider(provider);

          return provider;
        },
        child: const HomeClasses(),
      ),
    );
  }
}

class HomeClasses extends StatefulWidget {
  const HomeClasses({super.key});

  @override
  State<HomeClasses> createState() => _HomeClassesState();
}

class _HomeClassesState extends State<HomeClasses> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final tutorProvider = Provider.of<TutorProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      tutorProvider.loadMoreTutors();
    }
  }

  void _navigateToTeacherDetails(BuildContext context, TutorEntity tutor) {
    if (tutor.id != null) {
      push(context, HomeTeacherDetails(
        teacherId: tutor.id!,
        photo: tutor.photo ?? "",
        teacherName: tutor.name!,
        sessionPrice: tutor.homePrice!,
        apiType: type.ApiType.home,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TutorProvider>(
      builder: (context, tutorProvider, child) {
        return ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: tutorProvider.tutors.length + (tutorProvider.hasMoreData ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < tutorProvider.tutors.length) {
              final tutor = tutorProvider.tutors[index];
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
                ),
              );
            } else if (tutorProvider.hasMoreData) {
              return Padding(
                padding: EdgeInsets.only(
                    top: 8.0, bottom: MediaQuery.of(context).padding.bottom),
                child: const Center(
                    child: CircularProgressIndicator(
                        color: Constants.appBarColor)),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}

