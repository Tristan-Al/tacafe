import 'package:flutter/material.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ProductDetailPage(product: product);
      })),
      child: Container(
        width: (MediaQuery.of(context).size.width / 2) - 25,
        height: 230,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: AppTheme.darkBrown, width: .5),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 194, 193, 193),
              offset: Offset(1.0, 1.0), //(x,y)
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                image: product.image == null
                    ? const DecorationImage(
                        image: AssetImage('assets/no-image.jpg'),
                        fit: BoxFit.cover)
                    : DecorationImage(
                        image: NetworkImage(product.image!), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            HeaderText(
              text: product.name,
              fontSize: 15,
              color: AppTheme.darkBrown,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                MyContainer(
                  text: 'S',
                  backgroundColor: AppTheme.brown,
                  borderColor: AppTheme.brown,
                  textColor: AppTheme.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                  onTap: () {},
                ),
                const SizedBox(
                  width: 5,
                ),
                MyContainer(
                  text: 'M',
                  borderColor: AppTheme.brown,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                  onTap: () {},
                ),
                const SizedBox(
                  width: 5,
                ),
                MyContainer(
                  text: 'L',
                  borderColor: AppTheme.brown,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: "${product.price}\$",
                  color: AppTheme.darkBrown,
                  fontSize: 20,
                ),
                const Icon(
                  Icons.add_circle_outlined,
                  color: AppTheme.brown,
                  size: 30,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
