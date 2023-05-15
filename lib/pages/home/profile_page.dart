import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/saitama.png'),
            backgroundColor: AppTheme.lightBrown,
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email),
            SizedBox(
              width: 20,
            ),
            HeaderText(text: '${user.email}', fontSize: 20),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email),
            SizedBox(
              width: 20,
            ),
            HeaderText(text: '${user.email}', fontSize: 20),
          ],
        ),
        SizedBox(
          height: 100,
        ),
        GestureDetector(
          onTap: () => signUserOut(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              HeaderText(text: 'Logout', fontSize: 20),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.logout_outlined,
                color: AppTheme.brown,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        )
      ],
    );
  }
}
