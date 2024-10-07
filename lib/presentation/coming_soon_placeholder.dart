import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

class AnimatedPlaceholderWidget extends StatefulWidget {
  final String featureName;
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  const AnimatedPlaceholderWidget({
    super.key,
    required this.featureName,
    required this.progress,
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.lightBlueAccent,
  });

  @override
  AnimatedPlaceholderWidgetState createState() => AnimatedPlaceholderWidgetState();
}

class AnimatedPlaceholderWidgetState extends State<AnimatedPlaceholderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: child,
                );
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: widget.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.build,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              '${widget.featureName} Coming Soon!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: LinearProgressIndicator(
                value: widget.progress,
                backgroundColor: widget.secondaryColor.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${(widget.progress * 100).toStringAsFixed(0)}% Complete',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const TextButton(
              onPressed: _launchURL,
              child: Text(
                'Check out findmytuition.com while this feature is in development.',
                style: TextStyle(
                  fontSize: 16, // Adjust font size as needed
                  color: Colors.blue, // Adjust color as needed
                ),
                textAlign: TextAlign.center, // Center align the text
              ),
            )

          ],
        ),
      ),
    );
  }
}

Future<void> _launchURL() async {
  const url = 'https://findmytuition.com'; // Replace with your URL
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
