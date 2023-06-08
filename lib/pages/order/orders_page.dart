import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/services/product_service.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppbar(text: 'Orders'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref("users/${FirebaseAuth.instance.currentUser!.uid}")
                      .child('orders')
                      .onValue,
                  builder: (context, snap) {
                    if (snap.hasData &&
                        !snap.hasError &&
                        snap.data!.snapshot.value != null) {
                      Map<String, dynamic> data = Map<String, dynamic>.from(
                          snap.data!.snapshot.value as Map);

                      List<Order> orders = [];
                      data.forEach(
                        (key, value) {
                          orders.add(Order.fromMap(
                              key, Map<String, dynamic>.from(value)));
                        },
                      );
                      // Sort by last date
                      orders.sort((a, b) => b.date.compareTo(a.date));
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          return _ItemContainer(
                            order: orders.elementAt(index),
                          );
                        },
                      );
                    } else {
                      return ErrorTemplate(
                        assetImage: 'assets/empty-order.png',
                        title: 'No orders yet!',
                        subtitle: 'When you make an order it will appear here',
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
    );
  }
}

class _ItemContainer extends StatelessWidget {
  final Order order;

  const _ItemContainer({required this.order});

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Colors.grey.shade200;
    const double radius = 15;
    int items = 0;
    List<Widget> children = [
      Container(
        color: bgColor,
        padding: const EdgeInsets.only(left: radius, right: radius, top: 15),
        width: double.infinity,
        child: Row(
          children: [
            const Icon(
              Icons.location_on,
              size: 25,
              color: AppTheme.brown,
            ),
            const SizedBox(
              width: 20,
            ),
            NormalText(
              text: 'Address: ${order.address}',
              fontSize: 17,
              color: Colors.black87,
            )
          ],
        ),
      ),
      Container(
        color: bgColor,
        padding: const EdgeInsets.only(left: radius, right: radius, top: 15),
        width: double.infinity,
        child: Row(
          children: [
            const Icon(
              Icons.attach_money_rounded,
              size: 25,
              color: AppTheme.brown,
            ),
            const SizedBox(
              width: 20,
            ),
            NormalText(
              text: 'Total: ${order.subtotal}\$',
              fontSize: 17,
              color: Colors.black87,
            )
          ],
        ),
      ),
      Container(
        color: bgColor,
        padding: const EdgeInsets.only(left: radius, right: radius, top: 15),
        width: double.infinity,
        child: Row(
          children: [
            const Icon(
              Icons.date_range_rounded,
              size: 25,
              color: AppTheme.brown,
            ),
            const SizedBox(
              width: 20,
            ),
            NormalText(
              text: DateFormat('dd MMMM yyyy \'at\' HH:mm').format(order.date),
              fontSize: 17,
              color: Colors.black87,
            )
          ],
        ),
      ),
      Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: radius, vertical: 15),
        width: double.infinity,
        child: const HeaderText(
          text: 'Your order',
          fontSize: 18,
        ),
      )
    ];

    order.products.forEach(
      (key, value) {
        items += value;
        children.add(Container(
          color: bgColor,
          padding: const EdgeInsets.symmetric(horizontal: radius, vertical: 15),
          width: double.infinity,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                color: Colors.grey.shade300,
                child: LightText(
                  text: value.toString(),
                  color: Colors.grey.shade800,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              NormalText(
                text: ProductService.getProduct(key).name,
                fontSize: 17,
                color: Colors.black87,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: NormalText(
                    text: '${ProductService.getProduct(key).price} \$',
                    fontSize: 17,
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          ),
        ));
      },
    );

    return Card(
      child: ExpansionTile(
        leading: const Icon(
          Icons.article_rounded,
          color: AppTheme.brown,
        ),
        title: Column(
          children: [
            Row(
              children: [
                NormalText(
                  text: '$items items',
                  fontSize: 18,
                ),
                const NormalText(
                  text: ' - ',
                  fontSize: 18,
                ),
                NormalText(
                  text: '${order.subtotal} \$',
                  fontSize: 18,
                ),
              ],
            ),
            Row(
              children: [
                NormalText(
                  text: order.status,
                  fontSize: 18,
                ),
                const NormalText(
                  text: ' - ',
                  fontSize: 18,
                ),
                NormalText(
                  text:
                      '${order.date.day} ${DateFormat('MMMM').format(order.date)}',
                  fontSize: 18,
                ),
              ],
            ),
          ],
        ),
        children: children,
      ),
    );
  }
}
