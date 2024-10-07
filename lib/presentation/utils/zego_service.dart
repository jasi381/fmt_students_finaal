import 'package:flutter/foundation.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoService {
  static final ZegoService _instance = ZegoService._internal();
  bool _isInitialized = false;

  factory ZegoService() {
    return _instance;
  }

  ZegoService._internal();

  Future<void> initialize(
      int appID,
      String appSign,
      String userID,
      String userName,
      ZegoUIKitSignalingPlugin signalingPlugin) async {
    if (!_isInitialized) {
      try {
        await ZegoUIKitPrebuiltCallInvitationService().init(
          appID: appID,
          appSign: appSign,
          userID: userID,
          userName: userName,
          plugins: [signalingPlugin],
        );
        await signalingPlugin.connectUser(
          id: userID,
          name: userName,
        );
        _isInitialized = true;
      } catch (e) {
        if (kDebugMode) {
          print("Error initializing Zego service: $e");
        }
      }
    }
  }
}
