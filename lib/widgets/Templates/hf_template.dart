import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';

class HFTemplate extends StatelessWidget {
  final Widget body;
  const HFTemplate({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBrown,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Stack(children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Image(
                  image: AssetImage('assets/bg-img.png'),
                  opacity: AlwaysStoppedAnimation(.2),
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Image(
                    fit: BoxFit.cover,
                    opacity: AlwaysStoppedAnimation(.2),
                    image: AssetImage('assets/bg-img.png'),
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/bg-img2.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: body,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
