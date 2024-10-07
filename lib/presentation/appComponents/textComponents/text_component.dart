import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class PoppinsText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final Color textColor;
  final int? maxLines;
  final TextOverflow? overflow;

  const PoppinsText(
      {super.key,
      required this.text,
      this.fontSize = 16,
      this.fontWeight = FontWeight.normal,
      this.fontStyle = FontStyle.normal,
      this.textColor = Colors.black,
      this.maxLines,
      this.overflow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          color: textColor),
    );
  }
}

/// Use roboto for body text, main content, and longer paragraphs.
/// Its readability at small sizes makes it ideal for general content.

class RobotoText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final Color textColor;
  final int? maxLines;
  final TextOverflow? overflow;

  const RobotoText(
      {super.key,
      required this.text,
      this.fontSize = 16,
      this.fontWeight = FontWeight.normal,
      this.fontStyle = FontStyle.normal,
      this.textColor = Colors.black,
      this.maxLines,
      this.overflow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.roboto(
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          color: textColor),
    );
  }
}
