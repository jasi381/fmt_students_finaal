import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

Future<T?> push<T>(BuildContext context, Widget child) {
  return pushWithoutNavBar<T>(
    context,
    Platform.isAndroid
        ? PageTransition(
      type: PageTransitionType.rightToLeft,
      duration: const Duration(milliseconds: 500),
      child: child,
    )
        : CupertinoPageRoute<T>(
      builder: (context) => child,
    ),
  );
}


Future<T?> pushReplacement<T extends Object?>(
    BuildContext context,
    Widget child
    ) {
  return pushReplacementWithoutNavBar<T, Object>(
    context,
    Platform.isAndroid
        ? PageTransition(
      type: PageTransitionType.rightToLeft,
      duration: const Duration(milliseconds: 500),
      child: child,
    )
        : CupertinoPageRoute<T>(
      builder: (context) => child,
    ),
  );
}



void pushAndRemoveUtil(BuildContext context, Widget child) {
  Navigator.pushAndRemoveUntil(
    context,
    Platform.isAndroid
        ? PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 500),
            child: child,
          )
        : CupertinoPageRoute(
            builder: (context) => child,
          ),
    (Route<dynamic> route) => false,
  );
}
