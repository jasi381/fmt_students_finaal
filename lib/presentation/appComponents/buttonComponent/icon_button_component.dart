import 'package:flutter/material.dart';

class IconButtonComponent extends StatelessWidget {
  final String text;
  final String assetPath;
  final Color color;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback onPressed;
  final bool iconOnRight;

  const IconButtonComponent({
    super.key,
    required this.text,
    required this.assetPath,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    required this.onPressed,
    this.iconOnRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Set width to fill available space
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: color,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!iconOnRight) ...[
              Image.asset(
                assetPath,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 8), // Space between icon and text
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
            if (iconOnRight) ...[
              const SizedBox(width: 8), // Space between text and icon
              Image.asset(
                assetPath,
                height: 24,
                width: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
