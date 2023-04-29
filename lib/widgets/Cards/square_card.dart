import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';

class SquareCard extends StatelessWidget {
  final String imagePath;
  final double height;
  final double borderRadius;
  final Function()? onTap;

  const SquareCard({
    super.key, 
    required this.imagePath,
    this.height = 30,
    this.borderRadius = 16, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(borderRadius),
          color: AppTheme.white,
        ),
        child: Image.asset(
          imagePath,
          height: height,
        ),
      ),
    );
  }
}