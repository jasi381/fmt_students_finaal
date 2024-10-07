import 'package:flutter/material.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyWebView extends StatefulWidget {
  const PrivacyPolicyWebView({super.key});

  @override
  PrivacyPolicyWebViewState createState() => PrivacyPolicyWebViewState();
}

class PrivacyPolicyWebViewState extends State<PrivacyPolicyWebView> {
  bool isLoading = true;
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const PoppinsText(
            text: "Privacy Policy",
            fontSize: 22,
            fontWeight: FontWeight.w500),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'https://findmytuition.com/privacy.php',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
            },
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : const Stack(),
        ],
      ),
    );
  }
}