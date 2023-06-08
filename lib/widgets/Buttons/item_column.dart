import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class ItemColumn extends StatelessWidget {
  const ItemColumn({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
    this.color,
  });

  final String text;
  final IconData? icon;
  final Color? color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(color: AppTheme.grey, width: .5),
        )),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Icon(
              icon,
              color: color ?? AppTheme.black,
            ),
            const SizedBox(
              width: 20,
            ),
            NormalText(
              text: text,
              fontSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}
