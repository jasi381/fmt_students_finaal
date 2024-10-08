import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';
import 'package:students/presentation/providers/student_profile_provider.dart';
import 'package:students/presentation/screens/call/call_screen.dart';
import 'package:students/presentation/screens/chat/chat_screen.dart';
import 'package:students/presentation/screens/classes/classes_screen.dart';
import 'package:students/presentation/screens/course/course_screen.dart';
import 'package:students/presentation/screens/home/home_screen.dart';
import 'package:students/presentation/utils/shared_pref_helper.dart';
import 'package:http/http.dart' as http;
import 'package:students/utils/constants.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedPreferencesHelper.setLoginStatus(true);
      _initializeZegoService(); // Call this directly
      _initializeData();
    });

  }
  Future<void> _initializeData() async {
    final profileNumber = await SharedPreferencesHelper.getPhoneNumber();

    if (profileNumber != null && mounted) {
      await Provider.of<ProfileProvider>(context, listen: false)
          .fetchStudentProfile(profileNumber);
      await _initializeZegoService();
    } else {
      Fluttertoast.showToast(msg: "Something went wrong. Please try again later");
    }
  }

  Future<void> _initializeZegoService() async {
    final profile = Provider.of<ProfileProvider>(context, listen: false).studentProfileEntity;
    ZegoCallData? currentCallData;
    if (profile != null) {
      try {
        await ZegoUIKitPrebuiltCallInvitationService().init(
          appID: Constants.appID,
          appSign:  Constants.appSign,
          userID: profile.studentProfile.email!,
          userName:  profile.studentProfile.name!,
          plugins: [ZegoUIKitSignalingPlugin()],
          events: ZegoUIKitPrebuiltCallEvents(
            onError:(ZegoUIKitError error){} ,
            // user: ZegoCallUserEvents(
            //     onLeave:(ZegoUIKitUser user){
            //     } ,
            //     onEnter: (ZegoUIKitUser user){
            //
            //     }
            // ),
            onCallEnd: (ZegoCallEndEvent event,  VoidCallback defaultAction,){
              String teacherId = currentCallData?.invitees.isNotEmpty == true
                  ? currentCallData!.invitees.first
                  : '1';  // Default to '1' if no invitee

              String callType = currentCallData?.callType??"voiceCall";
              scheduleCall(
                phone: profile.studentProfile.phone ?? '',
                teacherId: teacherId,
                date: DateTime.now().toString().split(' ')[0],
                time: DateTime.now().toString().split(' ')[1].substring(0, 5),
                callType: callType,
              ).then((success) {
                if (success) {
                  Fluttertoast.showToast(
                      msg: "Call ended successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: "Failed to end call",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }

              }).catchError((onError){
                Fluttertoast.showToast(
                    msg: "Failed to end call: ${onError.toString()}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              });
              defaultAction();
            },

            // Modify your custom configurations here.
            onHangUpConfirmation: (ZegoCallHangUpConfirmationEvent event,
                /// defaultAction to return to the previous page
                Future<bool> Function() defaultAction,
                ) async {
              return await showDialog(
                context: event.context,
                barrierDismissible: false,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title:  Text("Confirm Disconnecting with teacher",
                        style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18)),
                    content:  Text(
                        "Are you sure do you want to end the call with teacher",
                        style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 16)),
                    actions: [
                      TextButton(
                        child:  Text("Cancel",
                            style: GoogleFonts.poppins(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18)),
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                      ),
                      TextButton(
                        child: Text("Exit", style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 18)),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          requireConfig: (ZegoCallInvitationData data) {
            currentCallData = ZegoCallData(
                invitees: data.invitees.map((e) => e.id).toList(),
                inviterName: data.inviter?.name,
                callType:  data.type.name
            );
            var config = (data.invitees.length > 1)
                ? ZegoCallInvitationType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
                : ZegoCallInvitationType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();


            return config;
          },
        );

        // Wait for the signaling plugin to connect
        await ZegoUIKitSignalingPlugin().connectUser(
          id: profile.studentProfile.email!,
          name: profile.studentProfile.name!,
        );
      } catch (e) {
        if (kDebugMode) {
          print("Error initializing Zego service: $e");
        }
      }
    }
  }

  Future<bool> scheduleCall({
    required String phone,
    required String teacherId,
    required String date,
    required String time,
    required String callType,
  }) async {

    const String baseUrl = '${Constants.baseUrl}callschedule.php?API-Key=${Constants.apiKey}';


    final Uri uri = Uri.parse(baseUrl);


    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone': phone,
          'teacherid': teacherId,
          'date': date,
          'time': time,
          'calltype': callType,
        }),
      );


      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }



  List<PersistentTabConfig> _tabs() => [
        PersistentTabConfig(
          screen: HomeScreen(
            onCallIconPressed: () {
              _controller.jumpToTab(2);
            },
            onChatIconPressed: () {
              setState(() {
                _controller.jumpToTab(1);
              });
            },
          ),
          item: ItemConfig(
              icon: const ImageIcon(
                AssetImage("assets/icons/home_selected.png"),
              ),
              title: "Home",
              inactiveIcon: const ImageIcon(
                AssetImage("assets/icons/home_unselected.png"),
              ),
              activeForegroundColor: const Color(0xffff814e),
              inactiveForegroundColor: Colors.black87,
              textStyle: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w500)),
        ),
        PersistentTabConfig(
          screen: const ChatScreen(),
          item: ItemConfig(
              icon: const ImageIcon(
                AssetImage("assets/icons/chat_selected.png"),
              ),
              inactiveIcon: const ImageIcon(
                AssetImage(
                  "assets/icons/chat_unselected.png",
                ),
              ),
              title: "Chat",
              activeForegroundColor: const Color(0xffff814e),
              inactiveForegroundColor: Colors.black87,
              textStyle: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w500)),
        ),
        PersistentTabConfig(
          screen: const CallScreen(),
          item: ItemConfig(
              icon: const ImageIcon(
                AssetImage("assets/icons/call_selected.png"),
              ),
              inactiveIcon: const ImageIcon(
                AssetImage("assets/icons/call_unselected.png"),
              ),
              title: "Call",
              activeForegroundColor: const Color(0xffff814e),
              inactiveForegroundColor: Colors.black87,
              textStyle: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w500)),
        ),
        PersistentTabConfig(
          screen: const ClassesScreen(),
          item: ItemConfig(
              icon: const ImageIcon(
                AssetImage("assets/icons/class_selected.png"),
              ),
              inactiveIcon: const ImageIcon(
                AssetImage("assets/icons/class_unselected.png"),
              ),
              title: "Classes",
              activeForegroundColor: const Color(0xffff814e),
              inactiveForegroundColor: Colors.black87,
              textStyle: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w500)),
        ),
        PersistentTabConfig(
          screen:  const ImprovedCourseListView(),
          item: ItemConfig(
              icon: const ImageIcon(
                AssetImage("assets/icons/course_selected.png"),
              ),
              inactiveIcon: const ImageIcon(
                AssetImage("assets/icons/course_unselected.png"),
              ),
              title: "Courses",
              activeForegroundColor: const Color(0xffff814e),
              inactiveForegroundColor: Colors.black87,
              textStyle: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w500)),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller.index != 0) {
          if (kDebugMode) {
            print("Jumping to home tab");
          }
          setState(() {
            _controller.jumpToTab(0);
          });
          return false;
        }
        // Show a dialog to confirm app exit
        if (kDebugMode) {
          print("Showing exit dialog");
        }
        return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title:  const PoppinsText(text: 'Exit App',fontSize: 25,fontWeight: FontWeight.w500,),
                content: const RobotoText(text: 'Do you want to exit the app?',fontSize: 18,),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const PoppinsText(text: "No",fontSize: 15,),
                  ),
                  TextButton(
                    onPressed: () => SystemNavigator.pop(animated: true),
                    child: const PoppinsText(text: 'Yes',fontSize: 15,),
                  ),
                ],
              ),
            ) ??
            false;
      },
      child: PersistentTabView(
        controller: _controller,
        tabs: _tabs(),
        navBarBuilder: (navBarConfig) =>
            Style1BottomNavBar(navBarConfig: navBarConfig),
        popAllScreensOnTapAnyTabs: true,
      ),
    );
  }
}
