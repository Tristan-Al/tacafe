import 'package:flutter/material.dart';
import 'package:tacafe/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    String github = 'Tristan-Al';
    String phone = '638707471';
    String email = 'tristanalonso09@gmail.com';
    return Scaffold(
      appBar: DefaultAppbar(text: 'About'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(children: [
            const _ItemColumn(text: 'Version', subText: '0.1.123.0021'),
            const _ItemColumn(text: 'Author', subText: 'Tristan Alonso'),
            _ItemColumn(
              text: 'GitHub',
              subText: github,
              onTap: () => launchUrl(Uri.parse('https://github.com/$github')),
            ),
            _ItemColumn(
              text: 'Contact',
              subText: email,
              onTap: () => launchUrl(Uri(
                scheme: 'mailto',
                path: email,
                query: 'subject=&body=',
              )),
            ),
            _ItemColumn(
              text: 'Phone contact',
              subText: phone,
              onTap: () {
                launchUrl(Uri.parse('tel:+34 $phone'));
              },
            ),
          ]),
        ),
      ),
    );
  }
}

class _ItemColumn extends StatelessWidget {
  const _ItemColumn({required this.text, required this.subText, this.onTap});

  final String text;
  final String subText;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(color: AppTheme.grey, width: .5),
        )),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(
              text: text,
              fontSize: 20,
            ),
            NormalText(
              text: subText,
              fontSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}
