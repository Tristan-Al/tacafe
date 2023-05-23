import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/services/product_service.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print('Cart Page: Contains key \'cart\' : ${snapshot.data!.data()!.containsKey('cart')}');
            // print('Cart Page: \'cart\' : ${snapshot.data!.data()!['cart'].isEmpty}');
            if (!snapshot.data!.data()!.containsKey('cart') ||
                snapshot.data!.data()!['cart'].isEmpty) {
              return Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: MyElevatedButton(
                  onPressed: null,
                  gradient: LinearGradient(
                      colors: [Colors.grey[300]!, Colors.grey[300]!]),
                  borderRadius: BorderRadius.circular(5),
                  child: const Center(
                    child: HeaderText(
                        text: 'Go to checkout',
                        color: AppTheme.white,
                        fontSize: 20),
                  ),
                ),
              );
            } else {
              return Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: MyElevatedButton(
                  onPressed: () {},
                  gradient: const LinearGradient(
                      colors: [AppTheme.black, AppTheme.black]),
                  borderRadius: BorderRadius.circular(5),
                  child: const Center(
                    child: HeaderText(
                        text: 'Go to checkout',
                        color: AppTheme.white,
                        fontSize: 20),
                  ),
                ),
              );
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.article_rounded,
                    size: 25,
                    color: AppTheme.brown,
                  ),
                  HeaderText(
                    text: 'Orders',
                    fontSize: 15,
                    color: Colors.black87,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const HeaderText(
                text: 'BASKET',
                fontSize: 30,
              ),
              const SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.data()!['cart'] == null ||
                        !snapshot.data!.data()!.containsKey('cart')) {
                      return ErrorTemplate(
                        assetImage: 'assets/empty-cart.png',
                        title: 'Add items to start a basket',
                        subtitle:
                            'When you add an item your basket will appear here',
                        buttonText: 'Start shopping',
                        onTap: () {
                          selectedIndex = 0;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainPage(),
                            ),
                          );
                        },
                      );
                    } else {
                      Map<String, dynamic> cart =
                          snapshot.data!['cart'] as Map<String, dynamic>;

                      if (cart.isEmpty) {
                        return ErrorTemplate(
                          assetImage: 'assets/empty-cart.png',
                          title: 'Add items to start a basket',
                          subtitle:
                              'When you add an item your basket will appear here',
                          buttonText: 'Start shopping',
                          onTap: () {
                            selectedIndex = 0;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainPage(),
                              ),
                            );
                          },
                        );
                      } else {
                        return Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: cart.length,
                                itemBuilder: (context, index) {
                                  // subtotal += product.price;
                                  return _ItemContainer(
                                    item: cart.entries.elementAt(index),
                                  );
                                }),
                            FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('products')
                                    .get(),
                                builder: (context, snapshot) {
                                  // final Product product = Product.fromJson(snapshot.data!.data()!);
                                  return Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      decoration: BoxDecoration(),
                                      child: Row(
                                        children: [
                                          NormalText(
                                            text: 'Subtotal: ',
                                            fontSize: 20,
                                          ),
                                          NormalText(
                                            text: ' \$',
                                            fontSize: 20,
                                          )
                                        ],
                                      ));
                                })
                          ],
                        );
                      }
                    }
                  } else {
                    return const Center(
                      child: LightText(text: 'You dont have cart'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemContainer extends StatefulWidget {
  final MapEntry<String, dynamic> item;

  const _ItemContainer({super.key, required this.item});

  @override
  State<_ItemContainer> createState() => _ItemContainerState();
}

class _ItemContainerState extends State<_ItemContainer> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .doc(widget.item.key)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Product product = Product.fromJson(snapshot.data!.data()!);
            print(
                'CART PAGE: price: ${product.price}, uds: ${widget.item.value}, suma: ${product.price * widget.item.value}');
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppTheme.grey, width: 0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: product.image == null
                          ? const DecorationImage(
                              image: AssetImage('assets/no-image.jpg'),
                              fit: BoxFit.cover)
                          : DecorationImage(
                              image: NetworkImage(product.image!),
                              fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            HeaderText(
                              text: product.name,
                              fontSize: 18,
                            ),
                            LightText(
                              text: '${product.price} \$',
                              color: Colors.grey.shade800,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (widget.item.value > 1) {
                                  ProductService.decrementProductToCard(
                                      widget.item.key);
                                } else {
                                  ProductService.deleteProductToCard(
                                      widget.item.key);
                                }
                              },
                              icon: widget.item.value > 1
                                  ? const Icon(Icons.remove_circle)
                                  : const Icon(Icons.delete),
                              color: AppTheme.black,
                              iconSize: 20,
                            ),
                            LightText(
                              text: widget.item.value.toString(),
                              color: Colors.grey.shade800,
                            ),
                            IconButton(
                              onPressed: () {
                                ProductService.incrementProductToCard(
                                    widget.item.key);
                              },
                              icon: Icon(Icons.add_circle_rounded),
                              color: AppTheme.black,
                              iconSize: 20,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
