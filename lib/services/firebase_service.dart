import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/models/models.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Stream<List<MyUser>> getUsers2() {
  return db.collection('users').snapshots().map((snapshot) => snapshot.docs
      .map((document) => MyUser.fromJson(document.data()))
      .toList());
}

Future<List<MyUser>> getUsers() async {
  List<MyUser> users = [];
  CollectionReference<MyUser> userReference =
      db.collection('users').withConverter<MyUser>(
            fromFirestore: (snapshot, _) => MyUser.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          );

  QuerySnapshot<MyUser> querySnapshot = await userReference.get();

  querySnapshot.docs.forEach((document) {
    users.add(document.data());
  });

  return users;
}

Future<List> getUsers3() async {
  List users = [];
  CollectionReference collectionReference = db.collection("users");

  QuerySnapshot querySnapshot = await collectionReference.get();

  querySnapshot.docs.forEach((document) {
    users.add(document.data());
  });

  return users;
}

Future<Object> getUser(String email) async {
  return await db.collection('users').where('email', isEqualTo: email);
}
