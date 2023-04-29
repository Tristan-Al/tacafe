import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';

class LightText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  
  const LightText({
    super.key,
    required this.text,
    this.color = AppTheme.grey, 
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}