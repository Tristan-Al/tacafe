import 'package:flutter/material.dart';

class MyUser {
  String? id;
  String email;
  String name;
  String? image;
  String address;
  String? password;

  MyUser({
    required this.email,
    required this.name,
    this.image,
    required this.address,
    this.password,
  });

  MyUser.fromJson(Map<String, dynamic?> json)
      : this(
          email: json['email'] as String,
          name: json['name'] as String,
          address: json['address'] as String,
        );

  Map<String, Object> toJson() {
    return {
      'email': email,
      'name': name,
      'address': address,
    };
  }
}
