import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      FirebaseFirestore.instance
          .collection('users')
          .doc(result.user!.uid)
          .get()
          .then((value) {
        // If user not exist
        if (!value.exists) {
          // Save user to database
          FirebaseFirestore.instance
              .collection('users')
              .doc(result.user!.uid)
              .set({
            'email': result.user!.email,
            'cart': {},
          });
        }
      });
    });
  }
}
