import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/services/services.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

double _delivery = 2;
Map<String, String> _payment = {};

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);

    if (userService.isLoading) return const LoadingPage();

    double subtotal = 0;
    return Scaffold(
      appBar: DefaultAppbar(
        text: 'Checkout',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 70,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 2, color: Colors.grey[400]!),
          ),
          color: AppTheme.white,
        ),
        padding: const EdgeInsets.only(right: 10, left: 10, top: 15),
        child: StreamBuilder(
          stream: FirebaseDatabase.instance
              .ref("users/${FirebaseAuth.instance.currentUser!.uid}")
              .onValue,
          builder: (context, snap) {
            if (snap.hasData &&
                !snap.hasError &&
                snap.data!.snapshot.value != null) {
              Map<String, dynamic> data =
                  Map<String, dynamic>.from(snap.data!.snapshot.value as Map);
              MyUser user = MyUser.fromMap(data);
              if (user.cards != null && user.address != null) {
                return MyElevatedButton(
                  onPressed: () {
                    Order order = Order(
                      address: user.address!,
                      date: DateTime.now(), //DateTime.now().toIso8601String(),
                      payment: _payment,
                      products: Map<String, int>.from(user.cart!),
                      status: "active",
                      subtotal: subtotal + _delivery,
                    );
                    // print(order);
                    UserService.createOrder(order).then((value) {
                      UserService.deleteUserCart();
                      Navigator.pushNamed(context, '/thanks_order');
                    });
                  },
                  gradient: const LinearGradient(
                      colors: [AppTheme.black, AppTheme.black]),
                  borderRadius: BorderRadius.circular(5),
                  child: const Center(
                    child: HeaderText(
                        text: 'Place order',
                        color: AppTheme.white,
                        fontSize: 20),
                  ),
                );
              } else {
                return MyElevatedButton(
                  onPressed: null,
                  gradient: const LinearGradient(
                    colors: [AppTheme.grey, AppTheme.grey],
                  ),
                  borderRadius: BorderRadius.circular(5),
                  child: const Center(
                    child: HeaderText(
                        text: 'Place Order',
                        color: AppTheme.white,
                        fontSize: 20),
                  ),
                );
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20, left: 20, right: 20, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                    stream: FirebaseDatabase.instance
                        .ref("users/${FirebaseAuth.instance.currentUser!.uid}")
                        .onValue,
                    builder: (context, snap) {
                      if (snap.hasData &&
                          !snap.hasError &&
                          snap.data!.snapshot.value != null) {
                        Map<String, dynamic> data = Map<String, dynamic>.from(
                            snap.data!.snapshot.value as Map);
                        MyUser user = MyUser.fromMap(data);
                        Map<String, dynamic> cart =
                            user.cart != null ? user.cart! : {};

                        subtotal = 0;
                        cart.forEach(
                          (key, value) {
                            Product tempProduct =
                                ProductService.getProduct(key);
                            subtotal += tempProduct.price * value;
                            subtotal =
                                double.parse(subtotal.toStringAsFixed(2));
                          },
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _TapContainer(
                              icon: user.address == null
                                  ? const Icon(
                                      Icons.location_on_rounded,
                                      color: Colors.red,
                                    )
                                  : const Icon(Icons.location_on_rounded),
                              text: user.address == null
                                  ? 'Add Address'
                                  : user.address!,
                              color: user.address == null
                                  ? Colors.red
                                  : AppTheme.black,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      TextEditingController formController =
                                          TextEditingController.fromValue(
                                              const TextEditingValue());
                                      return AlertDialog(
                                        title: const NormalText(
                                          text: 'Change address',
                                          fontSize: 20,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            MyTextFormField(
                                              controller: formController,
                                              labelText: 'Address',
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            MyElevatedButton(
                                              onPressed: () {
                                                if (formController
                                                    .text.isNotEmpty) {
                                                  FirebaseDatabase.instance
                                                      .ref(
                                                          "users/${FirebaseAuth.instance.currentUser!.uid}")
                                                      .update({
                                                    'address':
                                                        formController.text,
                                                  });
                                                  currentUser.address =
                                                      formController.text;
                                                  UserService.updateUser(
                                                      currentUser);
                                                  Navigator.pop(context);
                                                }
                                              },
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              child: const Text('Save'),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const HeaderText(
                              text: 'Sumary',
                              fontSize: 25,
                            ),
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
                            const SizedBox(
                              height: 20,
                            ),
                            _SubtotalContainer(
                                text: 'Subtotal', subtotal: subtotal),
                            _SubtotalContainer(
                                text: 'Delivery', subtotal: _delivery),
                            _SubtotalContainer(
                              text: 'Total',
                              subtotal: subtotal + _delivery,
                              color: AppTheme.black,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const HeaderText(
                              text: 'Payment',
                              fontSize: 25,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _PaymentContainer(
                              cards: user.cards ?? {},
                            ),
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
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentContainer extends StatelessWidget {
  final Map<String, MyCard> cards;

  const _PaymentContainer({required this.cards});

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      // THE USER DONT HAVE ANY CARDS REGISTERED
      return _TapContainer(
        onTap: () => Navigator.pushNamed(context, '/add_credit_card'),
        text: 'Add Payment Method',
        color: Colors.red,
      );
    } else {
      // THE USER HAVE CARDS REGISTERED
      //Check if the user have any active card
      if (cards.entries.any((element) => element.value.active == true)) {
        // THE USER HAVE A CARD ACTIVE
        MyCard card = cards.entries
            .firstWhere(
              (element) => element.value.active == true,
            )
            .value;
        //SET PAYMENT METHOD
        _payment = {'card': card.num};

        return _TapContainer(
          onTap: () => Navigator.pushNamed(context, '/credit_cards'),
          text:
              '*** ${card.num.toString().substring(card.num.toString().length - 4)}',
        );
      } else {
        //THE USER DONT HAVE ANY CARDS ACTIVE
        return _TapContainer(
          onTap: () => Navigator.pushNamed(context, '/credit_cards'),
          text: 'Select Payment Method',
          color: Colors.red,
        );
      }
    }
  }
}

class _TapContainer extends StatelessWidget {
  final Function() onTap;
  final Color color;
  final String text;
  final Icon icon;

  const _TapContainer({
    super.key,
    required this.onTap,
    this.color = AppTheme.black,
    required this.text,
    this.icon = const Icon(
      Icons.credit_card,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 10, vertical: 5),
              child: icon //Icons.location_on_rounded
              ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppTheme.grey, width: 0.5),
                ),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NormalText(
                      text: text,
                      // '*** ${card.num.toString().substring(card.num.toString().length - 4)}',
                      fontSize: 20,
                      color: color,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 15,
                      color: color,
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubtotalContainer extends StatelessWidget {
  const _SubtotalContainer({
    required this.subtotal,
    required this.text,
    this.color = Colors.black54,
  });
  final String text;
  final double subtotal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NormalText(
              text: '$text: ',
              fontSize: 16,
              color: color,
            ),
            NormalText(
              text: '$subtotal \$',
              fontSize: 16,
              color: color,
            ),
          ],
        ));
  }
}

class _ItemContainer extends StatelessWidget {
  final MapEntry<String, dynamic> item;

  const _ItemContainer({required this.item});
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    if (productService.isLoading) return const LoadingPage();

    Product product = ProductService.getProduct(item.key);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      color: Colors.grey.shade300,
                      child: LightText(
                        text: item.value.toString(),
                        color: Colors.grey.shade800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    NormalText(
                      text: product.name,
                      fontSize: 18,
                      color: AppTheme.black,
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: NormalText(
                          text: '${product.price} \$',
                          fontSize: 18,
                          color: AppTheme.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
