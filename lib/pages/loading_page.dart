import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/loading-coffee.gif'),
          backgroundColor: AppTheme.white,
        ),
      ),
    ));
  }
}
