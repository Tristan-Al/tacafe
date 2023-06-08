import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/models/user.dart';
import 'package:http/http.dart' as http;

class UserService extends ChangeNotifier {
  static FirebaseDatabase db = FirebaseDatabase.instance;
  final String _baseURL =
      'tacafe-67178-default-rtdb.europe-west1.firebasedatabase.app';
  static List<MyUser> users = [];
  bool isLoading = true;

  UserService() {
    loadUsers();
  }

  Future<List<MyUser>> loadUsers() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseURL, 'users.json');
    final resp = await http.get(url);

    final Map<String, dynamic> usersMap = json.decode(resp.body);

    usersMap.forEach((key, value) {
      value['cart'] = value['cart'] ?? {};
      final tempUser = MyUser.fromMap(value);
      tempUser.id = key;
      users.add(tempUser);
    });

    isLoading = false;
    notifyListeners();

    return users;
  }

  static MyUser getUser(String id) {
    return users.where((element) => element.id == id).isNotEmpty
        ? users.where((element) => element.id == id).first
        : MyUser(cart: {}, email: 'email', cards: {}, orders: {});
  }

  // static MyUser? getCurrentUser() {
  //   return users
  //           .where((element) =>
  //               element.id == FirebaseAuth.instance.currentUser!.uid)
  //           .isNotEmpty
  //       ? users.singleWhere(
  //           (element) => element.id == FirebaseAuth.instance.currentUser!.uid)
  //       : null;
  // }

  static updateUser(MyUser user) {
    MyUser oldValue = users.singleWhere((element) => element.id == user.id);
    users[users.indexOf(oldValue)] = user;
  }

//   static Future setAllCardsUnactive() async{
// FirebaseDatabase.instance
//         .ref("users/${FirebaseAuth.instance.currentUser!.uid}")
//         .child('cards')
//   }
//Method that set all active cards to false and set parameter card active
  static Future updateUserCards(MyCard card, String cardId) async {
    DatabaseReference cardsRef = FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}")
        .child('cards');

    cardsRef.once().then((event) {
      DataSnapshot snapshot = event.snapshot;
      // print('SNAPSHOT: $snapshot');
      dynamic data = snapshot.value;
      // print('DYNAMIC: $data');
      if (data is Map) {
        // print('DATA ES MAP!!');
        Map<dynamic, dynamic> cards = data.cast<String, dynamic>();
        // print('CARDS: $cards');
        cards.forEach((key, value) {
          if (key != cardId) {
            cardsRef.child(key).update({'active': false});
          } else {
            cardsRef.child(key).update({'active': true});
          }
          // .then((value) => print('UPDATE TO FALSE SUCCESFYULLY'));
        });
      }
    }).then((value) {
      if (cardId.isEmpty) {
        FirebaseDatabase.instance
            .ref("users/${FirebaseAuth.instance.currentUser!.uid}")
            .child('cards')
            .push()
            .set(card.toMap());
      }
    });

    // FirebaseDatabase.instance
    //     .ref("users/${FirebaseAuth.instance.currentUser!.uid}")
    //     .child('cards')
    //     .update(databaseCards)
    //     .then((value) => {print('UPDATE DATBASE SUCCESFULLY')});
  }

  static void saveCreditCard(MyCard card) {
    FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}")
        .child('cards')
        .push()
        .set(card);
  }

  static void deleteUserCart() {
    FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}")
        .child('cart')
        .remove();
  }

  // Método para crear un nuevo pedido en la base de datos
  static Future<void> createOrder(Order order) async {
    final databaseReference = FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}");

    return await databaseReference.child('orders').push().set(order.toMap());
  }

  // Método para obtener un pedido por su ID
  static Future<Order?> getOrderById(String id) async {
    final databaseReference = FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}");

    final snapshot = await databaseReference.child('orders/$id').once();

    final dynamic orderValue = snapshot.snapshot.value;

    if (orderValue != null && orderValue is Map<String, dynamic>) {
      final Map<String, dynamic> orderMap =
          Map<String, dynamic>.from(orderValue);

      return Order.fromMap(snapshot.snapshot.key!, orderMap);
    } else {
      return null;
    }
  }

  // Método para actualizar un pedido
  Future<void> updateOrder(String id, Order order) async {
    final databaseReference = FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}");

    return await databaseReference.child('orders/$id').update(order.toMap());
  }

  // Método para eliminar un pedido
  Future<void> deleteOrder(String id) async {
    final databaseReference = FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}");

    return await databaseReference.child('orders/$id').remove();
  }
}
