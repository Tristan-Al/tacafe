import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class MyContainer extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final double fontSize;
  final Function()? onTap;

  MyContainer({
    super.key,
    required this.text,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    this.backgroundColor = AppTheme.white,
    this.borderColor = AppTheme.white,
    this.textColor = AppTheme.brown,
    this.fontSize = 13,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: backgroundColor,
        ),
        child: HeaderText(
          text: text,
          fontSize: fontSize,
          color: textColor,
        ),
      ),
      onTap: onTap,
    );
  }
}
