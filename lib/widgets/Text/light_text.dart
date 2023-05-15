import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';

class LightText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final TextAlign? textAlign;
  const LightText({
    super.key,
    required this.text,
    this.color = AppTheme.grey,
    this.fontSize = 20,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
