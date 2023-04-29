import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HFTemplate( body: _Body() );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 80, top: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            width: 180,
            height: 180,
            child: Image(image: AssetImage('assets/maintenance.png'))
          ),
          Column(
            children: [
              HeaderText(text: 'Oops', fontSize: 30,),
              LightText(text: 'This page is unde maintenance. We\'re working on it!',),
            ],
          ),
          MyElevatedButton(
            onPressed: () => {Navigator.pop(context)},
            width: double.infinity, 
            borderRadius: BorderRadius.circular(10),
            child: const LightText(text: 'Back to home page', color: AppTheme.white,),
          ),
        ],
      ),
    );
  }
}