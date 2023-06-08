import 'package:flutter/material.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/product_detail', arguments: product),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 120,
                child: product.image == null
                    ? const Image(
                        image: AssetImage('assets/no-image.jpg'),
                        fit: BoxFit.cover,
                      )
                    : FadeInImage(
                        image: NetworkImage(product.image!),
                        fit: BoxFit.cover,
                        placeholder: const AssetImage('assets/loading.gif'),
                      ),
              ),
            ),
            HeaderText(
              text: product.name,
              fontSize: 15,
              color: AppTheme.darkBrown,
            ),
            // Row(
            //   children: [
            //     MyContainer(
            //       text: 'S',
            //       backgroundColor: AppTheme.brown,
            //       borderColor: AppTheme.brown,
            //       textColor: AppTheme.white,
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
            //       onTap: () {},
            //     ),
            //     const SizedBox(
            //       width: 5,
            //     ),
            //     MyContainer(
            //       text: 'M',
            //       borderColor: AppTheme.brown,
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
            //       onTap: () {},
            //     ),
            //     const SizedBox(
            //       width: 5,
            //     ),
            //     MyContainer(
            //       text: 'L',
            //       borderColor: AppTheme.brown,
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
            //       onTap: () {},
            //     ),
            //   ],
            // ),
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
