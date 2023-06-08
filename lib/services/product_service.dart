import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService extends ChangeNotifier {
  final String _baseURL =
      'tacafe-67178-default-rtdb.europe-west1.firebasedatabase.app';
  static List<Product> products = [];
  bool isLoading = true;

  ProductService() {
    loadProducts();
  }

  Future loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'products.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final temProduct = Product.fromMap(value);
      temProduct.id = key;
      products.add(temProduct);
      // print(temProduct);
    });

    isLoading = false;
    notifyListeners();

    print('products loaded');
    return products;
  }

  static List getCategories(List<Product> listProducts) {
    Set categories = {};
    for (Product element in listProducts) {
      categories.add(element.category);
    }
    return categories.toList();
  }

  static List<Product> getProductsOfCategory(
      List<Product> listProducts, String category) {
    return listProducts
        .where((element) => element.category == category)
        .toList();
  }

  static Product getProduct(String productId) {
    // FirebaseDatabase.instance.ref('/products')
    return products.where((element) => element.id == productId).isNotEmpty
        ? products.where((element) => element.id == productId).first
        : Product(
            category: '', description: '', name: 'name', price: -1, stock: -1);
  }

  static incrementProductToCart(String productId) {
    FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}")
        .child('cart')
        .update({
      productId: ServerValue.increment(1),
    });
  }

  static decrementProductToCart(String productId) {
    FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}")
        .child('cart')
        .update({
      productId: ServerValue.increment(-1),
    });
  }

  static deleteProductToCard(String productId) {
    FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}")
        .child('cart')
        .child(productId)
        .remove();
  }
}
