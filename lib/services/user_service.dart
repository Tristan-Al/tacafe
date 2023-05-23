import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/models/models.dart';

class UserService {
  static String idUser = FirebaseAuth.instance.currentUser!.uid;
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static CollectionReference<Map<String, dynamic>> collection =
      db.collection('users');

  static Future getUser() {
    return collection.doc(idUser).get();
  }

  static Stream getUserStream() {
    return collection.doc(idUser).snapshots();
  }

  static Future updateUser(MyUser user) async {
    collection.doc(user.id).update({
      'name': user.name,
      'phone': user.phone,
      'address': user.address,
    });
  }
}
