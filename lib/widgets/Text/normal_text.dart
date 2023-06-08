import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';

class NormalText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const NormalText({
    super.key,
    required this.text,
    this.color = AppTheme.black,
    this.fontSize = 35,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
