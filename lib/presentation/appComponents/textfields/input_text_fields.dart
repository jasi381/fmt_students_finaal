import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputTextFieldComponent extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final VoidCallback? onEditingComplete;
  final void Function(String)? onChanged;
  final int? minLines;
  final Icon? prefixIcon;

  final int? maxLines;

  final bool? enabled;

  final Color? textColor;

  const InputTextFieldComponent({
    super.key,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.onEditingComplete,
    this.minLines = 1,
    this.maxLines = 1,
    this.enabled = true,
    this.textColor = Colors.black87,
    this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      cursorColor: const Color(0xffFF8B59),
      cursorOpacityAnimates: true,
      cursorWidth: 2,
      style: enabled!
          ? GoogleFonts.roboto(color: textColor, fontSize: 16)
          : GoogleFonts.roboto(color: Colors.grey, fontSize: 16),
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon,
        prefixIconColor: const Color(0xff928fa6),
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xffd0d5dd),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black54),
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(12),
        ),
        hintStyle: GoogleFonts.roboto(color: const Color(0xff928fa6)),
      ),
    );
  }
}
