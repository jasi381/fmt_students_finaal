import 'package:flutter/material.dart';
import 'package:students/presentation/appComponents/textComponents/text_component.dart';

class ButtonComponent extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback onPressed;
  final double elevation;

  const ButtonComponent({
    super.key,
    required this.text,
    this.color = const Color(0XFFFF6E2F),
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
      this.borderRadius = 10,
      this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    required this.onPressed,
      this.elevation = 0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: color,
          padding: padding,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: PoppinsText(
          text: text,
          textColor: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
