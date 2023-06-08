import 'package:flutter/material.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class ThanksOrderPage extends StatelessWidget {
  const ThanksOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: const Color(0xFF2C2C2C),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/delivery.png')),
            const NormalText(
              text: 'Thanks for your order!',
              fontSize: 25,
              color: Color(0xFFD2AE82),
            ),
            const NormalText(
              text: 'Wait for the call',
              fontSize: 25,
              color: Color(0xFFD2AE82),
            ),
            const SizedBox(
              height: 50,
            ),
            MyElevatedButton(
              onPressed: () {
                selectedIndex = 0;
                Navigator.pushNamed(context, '/');
              },
              gradient: const LinearGradient(
                  colors: [Color(0xFFCB8A58), Color(0xFF562B1A)]),
              borderRadius: BorderRadius.circular(50),
              child: const Center(
                child: HeaderText(
                    text: 'Go to home', color: AppTheme.white, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
