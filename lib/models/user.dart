import 'dart:convert';

import 'package:tacafe/models/models.dart';

class MyUser {
  String? id;
  String? address;
  Map<String, dynamic>? cart;
  String email;
  Map<String, MyCard>? cards;
  Map<String, Order>? orders;
  String? name;
  String? phone;
  String? image;
  bool? admin;

  MyUser({
    this.address,
    required this.cart,
    required this.email,
    this.name,
    this.phone,
    required this.cards,
    required this.orders,
    this.admin,
    this.image,
  });

  factory MyUser.fromJson(String str) => MyUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyUser.fromMap(Map<String, dynamic> json) {
    return MyUser(
      address: json["address"],
      cart: json['cart'] != null
          ? (Map<String, dynamic>.from(json['cart'])).map(
              (key, value) => MapEntry(key, value),
            )
          : null,
      email: json["email"],
      name: json["name"],
      phone: json["phone"],
      cards: json['cards'] != null
          ? (Map<String, dynamic>.from(json['cards'])).map(
              (key, value) => MapEntry(
                  key, MyCard.fromMap(Map<String, dynamic>.from(value))),
            )
          : null,
      orders: json['orders'] != null
          ? (Map<String, dynamic>.from(json['orders'])).map(
              (key, value) => MapEntry(
                  key, Order.fromMap(key, Map<String, dynamic>.from(value))),
            )
          : null,
      image: json["image"],
      admin: json["admin"],
    );
  }

  Map<String, dynamic> toMap() => {
        "address": address,
        "cart": cart,
        "email": email,
        "name": name,
        "phone": phone,
        "cards": cards != null
            ? cards!.map((key, value) => MapEntry(key, value.toMap()))
            : null,
        "image": image,
        "admin": admin,
        'orders': orders != null
            ? orders!.map((key, value) => MapEntry(key, value.toMap()))
            : null,
      };

  @override
  String toString() {
    return 'User{ id:$id, email: $email';
  }

  bool isAdmin() {
    if (admin == null) {
      return false;
    }
    return admin!;
  }
}

class MyCard {
  String? id;
  bool active;
  dynamic cvv;
  String exp;
  String name;
  dynamic num;

  MyCard({
    this.id,
    required this.cvv,
    required this.exp,
    required this.num,
    required this.active,
    required this.name,
  });

  factory MyCard.fromJson(String str) => MyCard.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyCard.fromMap(Map<String, dynamic> json) => MyCard(
        name: json["name"],
        cvv: json["cvv"],
        exp: json["exp"],
        active: json["active"],
        num: json["num"],
      );

  Map<String, dynamic> toMap() => {
        "cvv": cvv,
        "name": name,
        "exp": exp,
        "num": num,
        "active": active,
      };

  @override
  String toString() =>
      'MyCard - id: $id, active: $active, cvv: $cvv, exp: $exp, name: $name, num: $num';
}

class Order {
  String? id;
  String address;
  DateTime date;
  Map<String, String> payment;
  Map<String, int> products;
  String status;
  double subtotal;

  Order({
    this.id,
    required this.address,
    required this.date,
    required this.payment,
    required this.products,
    required this.status,
    required this.subtotal,
  });

  static Order fromMap(String id, Map<String, dynamic> map) {
    return Order(
      id: id,
      address: map['address'],
      date: DateTime.parse(map['date']),
      payment: Map<String, String>.from(map['payment']),
      products: Map<String, int>.from(map['products']),
      status: map['status'],
      subtotal: map['subtotal'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'date': date.toIso8601String(),
      'payment': payment,
      'products': products,
      'status': status,
      'subtotal': subtotal,
    };
  }

  @override
  String toString() {
    return 'Order{ id: $id, address: $address, date: $date, payment: $payment, products: $products, subtotal: $subtotal, status: $status}';
  }
}
