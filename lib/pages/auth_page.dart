import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tacafe/pages/pages.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //if user is logged ih
          if (snapshot.hasData) {
            return HomePage();
          }

          //if user is NOT logged in
          else{
            return LoginPage();
          }
        },
      ),
    );
  }
}