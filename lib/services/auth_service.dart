// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tacafe/main.dart';
import 'package:tacafe/pages/home/main_page.dart';
import 'package:tacafe/services/services.dart';

class AuthService {
  //Google sign in
  signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((result) {
      if (UserService.getUser(result.user!.uid).id == null) {
        FirebaseDatabase.instance.ref("users/${result.user!.uid}").set({
          'email': result.user!.email,
        });
      }
      selectedIndex = 0;
    });
  }

  // sign user out method
  static signUserOut(context) {
    FirebaseAuth.instance.signOut().then((value) {
      // Restart App:
      // Remove any route in the stack
      Navigator.of(context).popUntil((route) => false);

      // Add the first route
      Navigator.pushNamed(context, '/app_state');
      selectedIndex = 0;
    });
  }
}
