import 'package:flutter/material.dart';
import 'package:movie_app_task/src/core/app_strings.dart';
class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final String? fontFamily;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  // Constructor with optional parameters
  CustomText({
    required this.text,
    this.fontSize = 18.0,
    this.textColor = Colors.black,
    this.fontFamily,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: textColor,
        fontFamily: fontFamily??AppStrings.poppinsRegular,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
    );
  }
}