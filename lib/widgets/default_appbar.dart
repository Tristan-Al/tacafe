import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class DefaultAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const DefaultAppbar({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.white,
      elevation: 1,
      iconTheme: const IconThemeData(
        color: AppTheme.grey,
      ),
      centerTitle: true,
      title: HeaderText(
        text: text,
        fontSize: 30,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
