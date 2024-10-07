import 'package:flutter/material.dart';

class SpacerWidget extends StatelessWidget {
  final double height;
  final double width;

  const SpacerWidget({super.key, this.height = 0.0, this.width = 0.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
