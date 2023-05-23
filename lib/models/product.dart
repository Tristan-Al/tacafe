import 'package:flutter/material.dart';

class Product {
  String? id;
  String name;
  String description;
  String? image;
  num price;
  int stock;

  Product({
    this.id,
    required this.name,
    required this.description,
    this.image,
    required this.price,
    required this.stock,
  });

  Product.fromJson(Map<String, dynamic?> json)
      : this(
          name: json['name'] as String,
          description: json['description'] as String,
          image: json['image'] as String,
          price: json['price'] as num,
          stock: json['stock'] as int,
        );

  Map<String, Object> toJson() {
    return {
      'id': id!,
      'name': name,
      'description': description,
      'image': image!,
      'price': price,
      'stock': stock,
    };
  }
}
