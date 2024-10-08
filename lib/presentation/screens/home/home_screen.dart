import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:students/data/datasources/home_booking_data_source.dart';
import 'package:students/data/models/blogs_model.dart';
import 'package:students/data/models/feeback_response_model.dart';
import 'package:students/data/models/feedback_body_model.dart';
import 'package:students/data/models/top_institutes_model.dart';
import 'package:students/domain/entities/tutor_entity.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';
import 'package:students/presentation/payment_test.dart';
import 'package:students/presentation/providers/home_provider.dart';
import 'package:students/presentation/providers/student_profile_provider.dart';
import 'package:students/presentation/providers/tutor_provider.dart';
import 'package:students/presentation/screens/SubjectTeachersScreen.dart';
import 'package:students/presentation/screens/auth/login_screen.dart';
import 'package:students/presentation/screens/blog_list_screen.dart';
import 'package:students/presentation/screens/call/teacher_details.dart';
import 'package:students/presentation/screens/classes/home_classes/home_teacher_details.dart';
import 'package:students/presentation/screens/home/search_screen.dart';
import 'package:students/presentation/screens/transaction_history.dart';
import 'package:students/presentation/utils/check_bal.dart';
import 'package:students/presentation/utils/navigate_to.dart';
import 'package:students/presentation/utils/shared_pref_helper.dart';
import 'package:students/utils/constants.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zpns/zego_zpns.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onChatIconPressed;
  final VoidCallback? onCallIconPressed;

  const HomeScreen({super.key, this.onChatIconPressed, this.onCallIconPressed});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;
  String? _balance ;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _controller
        .repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _initializeData();
    });

  }

  // Future<void> _initializeData() async {
  //   final profileNumber = await SharedPreferencesHelper.getPhoneNumber();
  //
  //   if (profileNumber != null && mounted) {
  //     await Provider.of<ProfileProvider>(context, listen: false)
  //         .fetchStudentProfile(profileNumber);
  //     await _initializeZegoService();
  //   } else {
  //     Fluttertoast.showToast(msg: "Something went wrong. Please try again later");
  //   }
  // }
  //
  //
  // Future<void> _initializeZegoService() async {
  //   final profile = Provider.of<ProfileProvider>(context, listen: false).studentProfileEntity;
  //   ZegoCallData? currentCallData;
  //   if (profile != null) {
  //     try {
  //       await ZegoUIKitPrebuiltCallInvitationService().init(
  //         appID: Constants.appID,
  //         appSign:  Constants.appSign,
  //         userID: profile.studentProfile.email!,
  //         userName:  profile.studentProfile.name!,
  //         plugins: [ZegoUIKitSignalingPlugin()],
  //         events: ZegoUIKitPrebuiltCallEvents(
  //           onError:(ZegoUIKitError error){} ,
  //           // user: ZegoCallUserEvents(
  //           //     onLeave:(ZegoUIKitUser user){
  //           //     } ,
  //           //     onEnter: (ZegoUIKitUser user){
  //           //
  //           //     }
  //           // ),
  //           onCallEnd: (ZegoCallEndEvent event,  VoidCallback defaultAction,){
  //             String teacherId = currentCallData?.invitees.isNotEmpty == true
  //                 ? currentCallData!.invitees.first
  //                 : '1';  // Default to '1' if no invitee
  //
  //             String callType = currentCallData?.callType??"voiceCall";
  //             scheduleCall(
  //               phone: profile.studentProfile.phone ?? '',
  //               teacherId: teacherId,
  //               date: DateTime.now().toString().split(' ')[0],
  //               time: DateTime.now().toString().split(' ')[1].substring(0, 5),
  //               callType: callType,
  //             ).then((success) {
  //               if (success) {
  //                 Fluttertoast.showToast(
  //                     msg: "Call ended successfully",
  //                     toastLength: Toast.LENGTH_SHORT,
  //                     gravity: ToastGravity.BOTTOM,
  //                     timeInSecForIosWeb: 1,
  //                     backgroundColor: Colors.green,
  //                     textColor: Colors.white,
  //                     fontSize: 16.0
  //                 );
  //               } else {
  //                 Fluttertoast.showToast(
  //                     msg: "Failed to end call",
  //                     toastLength: Toast.LENGTH_SHORT,
  //                     gravity: ToastGravity.BOTTOM,
  //                     timeInSecForIosWeb: 1,
  //                     backgroundColor: Colors.red,
  //                     textColor: Colors.white,
  //                     fontSize: 16.0
  //                 );
  //               }
  //
  //             }).catchError((onError){
  //               Fluttertoast.showToast(
  //                   msg: "Failed to end call: ${onError.toString()}",
  //                   toastLength: Toast.LENGTH_SHORT,
  //                   gravity: ToastGravity.BOTTOM,
  //                   timeInSecForIosWeb: 1,
  //                   backgroundColor: Colors.red,
  //                   textColor: Colors.white,
  //                   fontSize: 16.0
  //               );
  //             });
  //             defaultAction();
  //           },
  //
  //           // Modify your custom configurations here.
  //           onHangUpConfirmation: (ZegoCallHangUpConfirmationEvent event,
  //               /// defaultAction to return to the previous page
  //               Future<bool> Function() defaultAction,
  //               ) async {
  //             return await showDialog(
  //               context: event.context,
  //               barrierDismissible: false,
  //               builder: (BuildContext dialogContext) {
  //                 return AlertDialog(
  //                   backgroundColor: Colors.white,
  //                   title:  Text("Confirm Disconnecting with teacher",
  //                       style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18)),
  //                   content:  Text(
  //                       "Are you sure do you want to end the call with teacher",
  //                       style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 16)),
  //                   actions: [
  //                     TextButton(
  //                       child:  Text("Cancel",
  //                           style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18)),
  //                       onPressed: () => Navigator.of(dialogContext).pop(false),
  //                     ),
  //                     TextButton(
  //                       child: Text("Exit", style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 18)),
  //                       onPressed: () {
  //                         Navigator.of(dialogContext).pop(true);
  //                       },
  //                     ),
  //                   ],
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //         requireConfig: (ZegoCallInvitationData data) {
  //           currentCallData = ZegoCallData(
  //               invitees: data.invitees.map((e) => e.id).toList(),
  //               inviterName: data.inviter?.name,
  //               callType:  data.type.name
  //           );
  //           var config = (data.invitees.length > 1)
  //               ? ZegoCallInvitationType.videoCall == data.type
  //               ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
  //               : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
  //               : ZegoCallInvitationType.videoCall == data.type
  //               ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
  //               : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
  //
  //
  //           return config;
  //         },
  //       );
  //
  //       // Wait for the signaling plugin to connect
  //       await ZegoUIKitSignalingPlugin().connectUser(
  //         id: profile.studentProfile.email!,
  //         name: profile.studentProfile.name!,
  //       );
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print("Error initializing Zego service: $e");
  //       }
  //     }
  //   }
  // }
  //
  // Future<bool> scheduleCall({
  //   required String phone,
  //   required String teacherId,
  //   required String date,
  //   required String time,
  //   required String callType,
  // }) async {
  //
  //   const String baseUrl = '${Constants.baseUrl}callschedule.php?API-Key=${Constants.apiKey}';
  //
  //
  //   final Uri uri = Uri.parse(baseUrl);
  //
  //
  //   try {
  //     final response = await http.post(
  //       uri,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'phone': phone,
  //         'teacherid': teacherId,
  //         'date': date,
  //         'time': time,
  //         'calltype': callType,
  //       }),
  //     );
  //
  //
  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<void> _updateBalance() async {
    try {
      String? balance = await WalletService.fetchWalletBalance();
      if (balance != null) {
        setState(() {
          _balance = balance;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch balance: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context, listen: false).studentProfileEntity;
    _updateBalance();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CustomAppBar(scaffoldKey: _scaffoldKey,balance: _balance,)),
      drawer: CustomDrawer( onChatIconPressed: widget.onChatIconPressed,onCallIconPressed: widget.onCallIconPressed,),
      floatingActionButton: CustomBottomNavigationBar(
        onChatIconPressed: widget.onChatIconPressed,
        onCallIconPressed: widget.onCallIconPressed,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: HomeBody(
          controller: _controller,
          onChatClicked: widget.onChatIconPressed,
          studentClass : profile?.studentProfile.userClass

      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  final AnimationController controller;
  final VoidCallback? onChatClicked;
  final String? studentClass;

  const HomeBody(
      {super.key,
        required this.controller,
        required this.onChatClicked, required this.studentClass});




  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SearchCard(
            onCardClicked: () {
              push(context, SearchScreen(studentClass:studentClass! ));
            },
          ),
        ),
        const SliverToBoxAdapter(
          child: SubjectsList(),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 7,
            color: const Color(0xffececec),
          ),
        ),
        SliverToBoxAdapter(
          child: LottieCard(
            controller: controller,
            onBannerClick: onChatClicked,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 7,
            color: const Color(0xffececec),
          ),
        ),
        const SliverToBoxAdapter(
          child: TopTeachersLayout(),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 7,
            color: const Color(0xffececec),
          ),
        ),
        const SliverToBoxAdapter(
          child: TopInstitutesLayout(),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 7,
            color: const Color(0xffececec),
          ),
        ),
        const SliverToBoxAdapter(
          child: BlogsLayout(),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 7,
            color: const Color(0xffececec),
          ),
        ),
        const SliverToBoxAdapter(child: FeedbackWidget()),
        SliverToBoxAdapter(
          child: Container(
            height: 7,
            color: const Color(0xffececec),
          ),
        ),
        const SliverToBoxAdapter(child: FeatureContainers()),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom + 50),
        ),
      ],
    );
  }
}

class FeedbackWidget extends StatefulWidget {
  const FeedbackWidget({super.key});

  @override
  FeedbackWidgetState createState() => FeedbackWidgetState();
}

class FeedbackWidgetState extends State<FeedbackWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;


  void submitData() async {
    setState(() {
      _isLoading = true;
    });
    final Uri url = Uri.parse(
        '${Constants.baseUrl}studentfeedback.php?API-Key=${Constants.apiKey}');

    var phone = await SharedPreferencesHelper.getPhoneNumber();
    final String feedback = _controller.text;

    final submitRequest = SubmitRequest(
      phone: phone!,
      comment: feedback,
    );

    if (feedback.isNotEmpty) {
      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(submitRequest.toJson()),
        );

        // Check if the request was successful
        if (response.statusCode == 200) {
          final submitResponse =
          SubmitResponse.fromJson(json.decode(response.body));

          if (submitResponse.success) {
            if (mounted) {
              FocusScope.of(context).unfocus();
              _controller.clear();
            }
          } else {
            Fluttertoast.showToast(msg: "Something went wrong");
          }
        } else {
          Fluttertoast.showToast(msg: "Something went wrong");
        }
      } catch (error) {
        Fluttertoast.showToast(msg: "Something went wrong");
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }else{
      Fluttertoast.showToast(msg: "Empty feedback cannot be submitted");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 11),
      child: Card(
        elevation: 4,
        color: const Color(0xfff0f0f0),
        margin: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PoppinsText(
                    text: 'Feedback to the CEO office!',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  Text(
                    'Share your feedback to help us improve the app',
                    style: GoogleFonts.roboto(
                      fontSize: 12.5,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _controller,
                    maxLines: 5,
                    style: GoogleFonts.roboto(),
                    decoration: InputDecoration(
                      hintText: 'Start typing here...',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Constants.appBarColor,
                        // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 26.0, vertical: 6.0),
                      ),
                      onPressed: submitData,
                      child: const PoppinsText(
                        text: 'Send Feedback',
                        textColor: Constants.appBarContentColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Constants.appBarColor),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SearchCard extends StatelessWidget {
  final VoidCallback onCardClicked;

  const SearchCard({super.key, required this.onCardClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      color: const Color(0xffececec),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: onCardClicked,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(CupertinoIcons.search, color: Colors.grey),
                SizedBox(width: 4),
                PoppinsText(
                  text: "Find a teacher in your preferred mode.",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubjectsList extends StatefulWidget {


  const SubjectsList({super.key});

  @override
  State<SubjectsList> createState() => _SubjectsListState();
}

class _SubjectsListState extends State<SubjectsList> {
  String trimAndAddEllipsis(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    } else {
      return text;
    }
  }

  String trimAndCapitalizeFirstChar(String text, int maxLength) {
    if (text.isEmpty) {
      return '';
    }

    String trimmedText = text.length > maxLength ? text.substring(0, maxLength) : text;
    return trimmedText[0].toUpperCase() + trimmedText.substring(1).toLowerCase();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 95,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            if (homeProvider.isSubjectsLoading) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,  // Placeholder count for shimmer effect
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 60,
                            height: 10,
                            color: Colors.white,
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            } else if (homeProvider.subjectsError != null) {
              return Text('Error: ${homeProvider.subjectsError}');
            } else if (homeProvider.subjects != null) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeProvider.subjects!.subjectList.length,
                itemBuilder: (context, index) {
                  var subject = homeProvider.subjects!.subjectList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              push(context, SubjectTeachersScreen(subject: subject));
                            },

                            borderRadius: BorderRadius.circular(25),
                            splashColor: Colors.black.withOpacity(0.3),
                            highlightColor: Colors.black.withOpacity(0.1),
                            child: Ink(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Constants.appBarColor,
                              ),
                              child: Center(
                                child: PoppinsText(
                                  text: trimAndCapitalizeFirstChar(subject, 2),
                                  textColor: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        RobotoText(
                          text: trimAndAddEllipsis(subject, 4),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Text('No data');
            }
          },
        ),
      ),
    );
  }
}

class TopTeachersLayout extends StatelessWidget {

  const TopTeachersLayout(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.33,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PoppinsText(
              text: "Teachers",
              fontWeight: FontWeight.w500,
              fontSize: 19,
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: Consumer<TutorProvider>(
                builder: (context, tutorProvider, child) {
                  final bestTutors = tutorProvider.bestTutors;
                  if (bestTutors.isEmpty) {
                    return const Center(child: Text('No best tutors available.'));
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bestTutors.length,
                      itemBuilder: (context, index) {
                        var teacher = bestTutors[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: TopTeachersCard(
                            teacher: teacher,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class BlogsLayout extends StatelessWidget {

  const BlogsLayout({super.key,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.28,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const PoppinsText(
                  text: "Latest from blog",
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                ),
                const Spacer(),
                Consumer<HomeProvider>(
                    builder:(context,homeProvider,child){
                      var blogs = homeProvider.blogs?.blogs;
                      return GestureDetector(
                        onTap: () {
                          push(context,  BlogListScreen(
                            blogs: blogs!,
                          ));
                        },
                        child: const RobotoText(
                          text: "View All",
                          fontSize: 14,
                          textColor: Colors.grey,
                        ),
                      );
                    }
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<HomeProvider>(
                builder: (context, homeProvider, child) {
                  if (homeProvider.isSubjectsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (homeProvider.subjectsError != null) {
                    return Center(child: Text('Error: ${homeProvider.subjectsError}'));
                  } else {
                    final blogs = homeProvider.blogs?.blogs ?? [];
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: blogs.take(5).length,
                      itemBuilder: (context, index) {
                        var blog = blogs[index];
                        return BlogsCard(blog: blog);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class TopInstitutesLayout extends StatelessWidget {

  const TopInstitutesLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.28,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PoppinsText(
              text: "Our top institutes",
              fontWeight: FontWeight.w500,
              fontSize: 19,
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: Consumer<HomeProvider>(
                builder: (context, homeProvider, child) {
                  if (homeProvider.isTopInstitutesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (homeProvider.topInstitutesError != null) {
                    return Center(child: Text('Error: ${homeProvider.topInstitutesError}'));
                  } else {
                    final topInstitutes = homeProvider.topCenters?.institutes ?? [];
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: topInstitutes.length,
                      itemBuilder: (context, index) {
                        var institute = topInstitutes[index];
                        return TopInstitutesCard(topInstitute: institute,);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureContainers extends StatelessWidget {
  const FeatureContainers({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFeatureContainer(
            iconPath: 'assets/icons/private_confidential.png',
            text: 'Private &\nConfidential',
          ),
          _buildFeatureContainer(
            iconPath: 'assets/icons/verified_teachers.png',
            text: 'Verified\nTeachers',
          ),
          _buildFeatureContainer(
            iconPath: 'assets/icons/secure_payments.png',
            text: 'Secure\nPayments',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureContainer({
    required String iconPath,
    required String text,
  }) {
    return Column(
      children: [
        Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              iconPath,
              width: 40,
              height: 40,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}

class LottieCard extends StatelessWidget {
  final AnimationController controller;
  final VoidCallback? onBannerClick;

  const LottieCard(
      {super.key, required this.controller, required this.onBannerClick});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: GestureDetector(
          onTap: onBannerClick,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Lottie.asset(
                        'assets/lottie/banner.json',
                        frameRate: const FrameRate(30),
                        controller: controller,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TopTeachersCard extends StatelessWidget {
  final TutorEntity teacher;

  const TopTeachersCard(
      {super.key, required this.teacher});

  void _navigateToTeacherDetails(BuildContext context, TutorEntity tutor) {
    if (tutor.id != null) {
      push(context, TeacherDetailsScreen(
        teacherId: tutor.id!,
        photo: tutor.photo ?? "",
        teacherName: tutor.name!,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        onTap:()=> _navigateToTeacherDetails(context,teacher),
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.38,
          child: ClipRRect(
            child: Banner(
              message: "Top Teacher",
              location: BannerLocation.topStart,
              textStyle:
              GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w400),
              color: Constants.appBarColor,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 18, left: 8, right: 8),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border:
                      Border.all(color: const Color(0XFFFF8B59), width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: teacher.photo??Constants.imgPlaceholder,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xffFF6E2F),
                              )),
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/images/img_pl.png"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RobotoText(
                      text: teacher.name!,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  RobotoText(
                    text: "₹${teacher.voice}",
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    textColor: Colors.black,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // Rounded corners
                      border: Border.all(
                        color: Colors.black45, // Border color
                        width: 1.0, // Border width
                      ),
                    ),
                    child: const PoppinsText(
                      text: "Call",
                      fontSize: 13,
                      textColor: Colors.black45,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BlogsCard extends StatelessWidget {
  final Blog blog;
  const BlogsCard({super.key, required this.blog});


  void _launchURL(BuildContext context,String url) async {
    final theme = Theme.of(context);
    try {
      await launchUrl(
        Uri.parse(url),
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
              toolbarColor: Constants.appBarColor,
              navigationBarColor: Constants.appBarColor,
              navigationBarDividerColor: Colors.transparent
          ),
          shareState: CustomTabsShareState.off,
          urlBarHidingEnabled: true,
          showTitle: false,
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: (){
          _launchURL(context,blog.slug);
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.55,
          child: ClipRRect(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.13,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: blog.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffFF6E2F),
                          )),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/images/img_pl.png"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RobotoText(
                    text: blog.title,
                    fontWeight: FontWeight.w400,
                    maxLines: 2,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopInstitutesCard extends StatelessWidget {
  final Institution topInstitute;

  const TopInstitutesCard({super.key, required this.topInstitute,});


  void _navigateToCenterDetails(BuildContext context) {
    push(context, HomeTeacherDetails(
      teacherId: topInstitute.id,
      photo: topInstitute.photo ,
      teacherName: topInstitute.name,
      sessionPrice: "0",
      apiType: ApiType.home,
    ));

  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        onTap: ()=>_navigateToCenterDetails(context),
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.55,
          child: ClipRRect(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: topInstitute.photo,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffFF6E2F),
                          )),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/images/img_pl.png"),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: RobotoText(
                      text: topInstitute.name,
                      fontWeight: FontWeight.w400,
                      maxLines: 1,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Button3D extends StatefulWidget {
  final VoidCallback? onPressed;
  final ImageIcon icon;
  final String text;
  final Color color;
  final Color effectColor;
  final double height;
  final double borderRadius;
  final double effectDepth;

  const Button3D({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.color,
    this.effectColor = Colors.black38,
    this.height = 38,
    this.borderRadius = 18,
    this.effectDepth = 1.5,
  });

  @override
  Button3DState createState() => Button3DState();
}

class Button3DState extends State<Button3D> {
  bool isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      isPressed = false;
    });
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  void _handleTapCancel() {
    setState(() {
      isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: widget.effectColor,
              offset: Offset(0, isPressed ? 0 : widget.effectDepth),
              blurRadius: 0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border(
              bottom: BorderSide(
                color: widget.effectColor,
                width: isPressed ? 0 : widget.effectDepth,
              ),
            ),
          ),
          child: Transform.translate(
            offset: Offset(0, isPressed ? widget.effectDepth : 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.icon,
                const SizedBox(width: 5),
                PoppinsText(
                  text: widget.text,
                  fontSize: 13,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final VoidCallback? onChatIconPressed;
  final VoidCallback? onCallIconPressed;

  const CustomBottomNavigationBar({
    super.key,
    this.onChatIconPressed,
    this.onCallIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Button3D(
              onPressed: onChatIconPressed,
              text: "Chat with teacher",
              icon: const ImageIcon(
                AssetImage("assets/icons/chat_selected.png"),
                color: Colors.white,
                size: 22,
              ),
              color: Constants.appBarColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Button3D(
              onPressed: onCallIconPressed,
              text: "Call with teacher",
              icon: const ImageIcon(
                AssetImage("assets/icons/call_selected.png"),
                color: Colors.white,
                size: 22,
              ),
              color: Constants.appBarColor,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String? balance;

  const CustomAppBar({super.key, required this.scaffoldKey, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10, bottom: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu_rounded),
            color: Colors.black,
          ),
          const PoppinsText(
            text: "Find My Tuition",
            fontSize: 19,
            fontWeight: FontWeight.w400,
          ),
          const Spacer(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 35,
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: balance == null
                        ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 35,
                        height: 25,
                        color: Colors.grey,
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: AutoSizeText(
                        "₹${balance!}",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  push(context, const RedeemCoinsScreen());
                },
                icon: const ImageIcon(
                  AssetImage("assets/icons/wallet.png"),
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  final VoidCallback? onChatIconPressed;
  final VoidCallback? onCallIconPressed;
  const CustomDrawer({super.key, required this.onChatIconPressed, required this.onCallIconPressed});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  Future<void> _setLoginStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', status);
  }

  void _logout() async {
    await _setLoginStatus(false);
    ZegoUIKitPrebuiltCallInvitationService().uninit();
    if (mounted) {
      pushReplacement(context, const LoginScreen());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<ProfileProvider>(
        builder: (context, profileNotifier, child) {
          // Fetch the profile when the drawer is built
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (profileNotifier.studentProfileEntity == null) {
              String? phoneNumber = await SharedPreferencesHelper.getPhoneNumber();
              profileNotifier.fetchStudentProfile(phoneNumber!);
            }
          });

          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _buildDrawerHeader(profileNotifier, context),
               DrawerItem(icon: Icons.chat_bubble_outline, text: 'Chat with Teacher',onPress: (){
                 widget.onChatIconPressed!();

              },),
               DrawerItem(icon: Icons.call_outlined, text: 'Talk with Teacher',onPress: (){
                widget.onCallIconPressed!();
              },),

              DrawerItem(icon: Icons.wallet_rounded, text: 'View Transactions',onPress: (){
                push(context,  const PaymentHistoryScreen());
              },),
              const SizedBox(height: 120), // Adjust this value as needed
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
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
          );
        },
      ),
    );
  }

  Widget _buildDrawerHeader(ProfileProvider profileNotifier, BuildContext context) {
    if (profileNotifier.isLoading) {
      return const DrawerHeader(
        decoration: BoxDecoration(color: Constants.appBarColor),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (profileNotifier.errorMessage != null) {
      return DrawerHeader(
        decoration: const BoxDecoration(color: Constants.appBarColor),
        child: Text(
          'Error: ${profileNotifier.errorMessage}',
          style: const TextStyle(color: Colors.white),
        ),
      );
    } else if (profileNotifier.studentProfileEntity != null) {
      final profile = profileNotifier.studentProfileEntity!.studentProfile;
      return DrawerHeader(
        decoration: const BoxDecoration(color: Constants.appBarColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                PoppinsText(
                  text :profile.name!,
                  textColor: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w500,

                ),
                const Spacer(),
                IconButton(onPressed: (){
                  Navigator.of(context).pop();
                }, icon: const Icon(Icons.close,color: Colors.white,))
              ],
            ),
            const Spacer(),
            RobotoText(
              text:profile.email!,
              textColor: Colors.white,
              fontSize: 19,
            ),
            RobotoText(
              text:profile.phone!,
              textColor: Colors.white,
              fontSize: 19,
            ),
          ],
        ),
      );
    } else {
      return const DrawerHeader(
        decoration: BoxDecoration(color: Constants.appBarColor),
        child: Text(
          'No profile data',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      );
    }
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onPress;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.text,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        if (onPress != null) {
          onPress!(); // Execute the onPress callback if provided
        }
      },
    );
  }
}

class ZegoCallData {
  final List<String> invitees;
  final String? inviterName;
  final String? callType;

  ZegoCallData({required this.invitees, this.inviterName,required this.callType});
}