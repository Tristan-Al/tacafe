import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/models/models.dart';

class ProductService {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<List> getProducts() async {
    List<Product> products = [];

    QuerySnapshot querySnapshot = await db.collection("products").get();

    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> productJson =
          document.data() as Map<String, dynamic>;

      Product product = Product.fromJson(productJson);

      product.id = document.id;

      products.add(product);
    });

    return products;
  }

  static Future<List> getProductswithCategory(String category) async {
    List<Product> products = [];

    QuerySnapshot querySnapshot = await db
        .collection("products")
        .where('category', isEqualTo: category)
        .get();

    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> productJson =
          document.data() as Map<String, dynamic>;

      Product product = Product.fromJson(productJson);

      product.id = document.id;

      products.add(product);
    });

    return products;
  }

  static Future<List> getCategories() async {
    List<String> categories = [];

    QuerySnapshot querySnapshot = await db.collection('categories').get();

    querySnapshot.docs.forEach((document) {
      Map<String, dynamic> categoryJson =
          document.data() as Map<String, dynamic>;

      categories.add(categoryJson['name']);
    });

    return categories;
  }

  static Future incrementProductToCard(String productId) async {
    db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'cart.$productId': FieldValue.increment(1),
    });
  }

  static Future decrementProductToCard(String productId) async {
    db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'cart.$productId': FieldValue.increment(-1),
    });
  }

  static Future deleteProductToCard(String productId) async {
    db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
      'cart.$productId': FieldValue.delete(),
    });
  }
}
