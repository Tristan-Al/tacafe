import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';

class MyIconButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final Function()? onPressed;

  const MyIconButton({
    super.key,
    required this.icon,
    this.backgroundColor = AppTheme.white,
    this.iconColor = AppTheme.lightBrown,
    this.size = 50,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}
