import 'package:flutter/material.dart';
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(
                  Icons.delivery_dining_rounded,
                  size: 50,
                  color: AppTheme.brown,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            HeaderText(
              text: 'YOUR ORDER:',
              fontSize: 20,
            ),
            const SizedBox(
              height: 30,
            ),
            _ItemContainer(),
            const SizedBox(
              height: 10,
            ),
            _ItemContainer(),
            const SizedBox(
              height: 10,
            ),
            _ItemContainer(),
            const SizedBox(
              height: 10,
            ),
            _ItemContainer(),
          ],
        ),
      ),
    );
  }
}

class _ItemContainer extends StatefulWidget {
  const _ItemContainer({
    super.key,
  });

  @override
  State<_ItemContainer> createState() => _ItemContainerState();
}

class _ItemContainerState extends State<_ItemContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.grey, width: .5),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                  image: NetworkImage(
                      'https://media-cldnry.s-nbcnews.com/image/upload/t_fit-1500w,f_auto,q_auto:best/newscms/2019_33/2203981/171026-better-coffee-boost-se-329p.jpg'),
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
                      text: 'Capuccino',
                      fontSize: 18,
                    ),
                    LightText(
                      text: '3 \$',
                      color: Colors.grey.shade800,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.remove_circle),
                      color: AppTheme.black,
                      iconSize: 20,
                    ),
                    LightText(
                      text: '1',
                      color: Colors.grey.shade800,
                    ),
                    IconButton(
                      onPressed: () {},
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
