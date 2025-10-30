import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rydyn/Driver/Widgets/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final int? maxLines;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Color labelColor;
  final Color textColor;
  final Color borderColor;
  final double fontSize;

  /// 🆕 New property
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.maxLines,
    this.suffix,
    this.inputFormatters,
    this.validator,
    this.labelColor = Colors.grey,
    this.textColor = korangeColor,
    this.borderColor = const Color(0xFFD5D7DA),
    this.fontSize = 16,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool showEditIcon =
        labelText.toLowerCase() != "phone number" &&
        !readOnly &&
        suffix == null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        obscureText: obscureText,
        readOnly: readOnly,
        maxLines: maxLines ?? 1,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
        validator:
            validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return "$labelText is required";
              }
              return null;
            },
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon:
              suffix ??
              (showEditIcon
                  ? const Icon(Icons.edit, color: KorangeLightColor, size: 18)
                  : null),
          labelStyle: GoogleFonts.poppins(color: labelColor, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kbordergreyColor, width: 2),
          ),
        ),
      ),
    );
  }
}
