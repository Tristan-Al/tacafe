import 'package:flutter/material.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/widgets/widgets.dart';

class ErrorTemplate extends StatelessWidget {
  final String assetImage;
  final String title;
  final String subtitle;
  final String buttonText;
  final void Function()? onTap;

  const ErrorTemplate({
    super.key,
    required this.assetImage,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Image(image: AssetImage(assetImage)),
          HeaderText(
            text: title,
            fontSize: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          LightText(
            text: subtitle,
            fontSize: 16,
          ),
          const SizedBox(
            height: 20,
          ),
          MyElevatedButton(
            onPressed: onTap,
            child: Text(buttonText),
          )
        ],
      ),
    );
  }
}
