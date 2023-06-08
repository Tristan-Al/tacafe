import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/services/services.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);

    if (userService.isLoading) return const LoadingPage();

    final String userId = FirebaseAuth.instance.currentUser == null
        ? '-1'
        : FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: StreamBuilder(
          stream: FirebaseDatabase.instance
              .ref("users/$userId")
              .child('cart')
              .onValue,
          builder: (context, snap) {
            if (snap.hasData &&
                !snap.hasError &&
                snap.data!.snapshot.value != null) {
              return Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: MyElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/checkout',
                    );
                  },
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
            } else {
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
            }
          }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/orders'),
                  child: Row(
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
                  stream: FirebaseDatabase.instance
                      .ref("users/$userId")
                      .child('cart')
                      .onValue,
                  builder: (context, snap) {
                    if (snap.hasData &&
                        !snap.hasError &&
                        snap.data!.snapshot.value != null) {
                      Map data = snap.data!.snapshot.value as Map;
                      Map<String, dynamic> cart = {};

                      double subtotal = 0;

                      data.forEach(
                        (key, value) {
                          print('CART PAGE: $key, $value');
                          cart.putIfAbsent(key, () => value);
                          Product tempProduct = ProductService.getProduct(key);
                          subtotal += tempProduct.price * value;
                          subtotal = double.parse(subtotal.toStringAsFixed(2));
                        },
                      );

                      return Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cart.length,
                              itemBuilder: (context, index) {
                                // subtotal += product.price;
                                return _ItemContainer(
                                  item: cart.entries.elementAt(index),
                                );
                              }),
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const HeaderText(
                                    text: 'Subtotal: ',
                                    fontSize: 23,
                                  ),
                                  HeaderText(
                                    text: '$subtotal \$',
                                    fontSize: 23,
                                  )
                                ],
                              )),
                        ],
                      );
                    } else {
                      return ErrorTemplate(
                        assetImage: 'assets/empty-cart.png',
                        title: 'Add items to start a basket',
                        subtitle:
                            'When you add an item your basket will appear here',
                        buttonText: 'Start shopping',
                        onTap: () {
                          selectedIndex = 0;
                          Navigator.pushNamed(context, '/');
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemContainer extends StatefulWidget {
  final MapEntry<String, dynamic> item;

  const _ItemContainer({required this.item});

  @override
  State<_ItemContainer> createState() => _ItemContainerState();
}

class _ItemContainerState extends State<_ItemContainer> {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    if (productService.isLoading) return const LoadingPage();

    Product product = ProductService.getProduct(widget.item.key);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.grey, width: 0.5)),
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
                      image: NetworkImage(product.image!), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
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
                          print(
                              'Item: ${product.name}, amount: ${widget.item.value}');
                          // currentUser.cart[widget.item.key] =
                          //     widget.item.value - 1;
                          ProductService.decrementProductToCart(
                              widget.item.key);
                        } else {
                          ProductService.deleteProductToCard(widget.item.key);
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
                        ProductService.incrementProductToCart(widget.item.key);
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
  }
}
