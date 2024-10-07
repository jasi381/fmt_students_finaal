import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SelectableOutlinedCard extends StatelessWidget {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final IconData? icon;
  final String text;
  final bool isSelected;
  final bool selectable;

  const SelectableOutlinedCard({
    super.key,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    this.icon,
    required this.text,
    required this.isSelected,
    this.selectable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:
           RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: isSelected && selectable ? borderColor:Colors.white,
      child: Opacity(
        opacity: selectable ? 1.0 : 0.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: isSelected && selectable ? Colors.white:Colors.black,),
                const SizedBox(width: 4),
              ],
              Text(
                text,
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected && selectable ? Colors.white:Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}