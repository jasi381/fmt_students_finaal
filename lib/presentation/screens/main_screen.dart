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
import 'package:students/presentation/utils/zego_service.dart';
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
    });

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
