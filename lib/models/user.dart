import 'package:flutter/material.dart';

class MyUser {
  String? id;
  String email;
  String name;
  String? phone;
  String? image;
  String address;
  String? password;

  MyUser({
    this.id,
    required this.email,
    required this.name,
    this.phone,
    this.image,
    required this.address,
    this.password,
  });

  MyUser.fromJson(Map<String, dynamic?> json)
      : this(
          id: json['id'],
          email: json['email'] ?? '',
          name: json['name'] ?? '',
          phone: json['phone'] ?? '',
          image: json['image'] ?? '',
          address: json['address'] ?? '',
        );

  Map<String, Object> toJson() {
    return {
      'email': email,
      'name': name,
      'address': address,
    };
  }
}
