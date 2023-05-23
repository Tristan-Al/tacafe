import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/services/services.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/Buttons/my_icon_button.dart';
import 'package:tacafe/widgets/widgets.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    double imgHeight = MediaQuery.of(context).size.height / 2.2;
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: double.infinity,
                height: imgHeight,
                decoration: BoxDecoration(
                  image: product.image == null
                      ? const DecorationImage(
                          image: AssetImage('assets/no-image.jpg'),
                          fit: BoxFit.cover)
                      : DecorationImage(
                          image: NetworkImage(product.image!),
                          fit: BoxFit.cover),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 10,
              child: MyIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: () => {Navigator.pop(context)},
              ),
            ),
            Positioned(
              top: imgHeight - 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 15,
                  right: 15,
                  bottom: 50,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppTheme.black.withOpacity(.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LightText(
                      text: product.name,
                      color: AppTheme.white,
                      fontSize: 25,
                    ),
                    MyContainer(
                      text: '★ 4.9',
                      backgroundColor: AppTheme.brown,
                      textColor: AppTheme.white,
                      borderColor: AppTheme.brown,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: imgHeight - 30,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderText(
                      text: 'Coffe Size',
                      color: AppTheme.black,
                      fontSize: 22,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyContainer(
                          text: 'Small',
                          backgroundColor: AppTheme.brown,
                          borderColor: AppTheme.brown,
                          textColor: AppTheme.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          fontSize: 15,
                          onTap: () {},
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        MyContainer(
                          text: 'Medium',
                          borderColor: AppTheme.brown,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          fontSize: 15,
                          onTap: () {},
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        MyContainer(
                          text: 'Large',
                          borderColor: AppTheme.brown,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          fontSize: 15,
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const HeaderText(
                      text: 'About',
                      color: AppTheme.black,
                      fontSize: 22,
                    ),
                    const SizedBox(height: 10),
                    LightText(
                      text: product.description,
                      fontSize: 15,
                      textAlign: TextAlign.start,
                      color: AppTheme.darkBrown,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 20,
                right: 40,
                left: 40,
                child: MyElevatedButton(
                  gradient: const LinearGradient(
                      colors: [AppTheme.black, AppTheme.black]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const LightText(
                          text: 'Add to Cart',
                          fontSize: 25,
                          color: AppTheme.white,
                        ),
                        LightText(
                          text: '|    ${product.price} \$',
                          fontSize: 25,
                          color: AppTheme.white,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    // show loading circle
                    showDialog(
                        context: context,
                        builder: ((context) => const Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.lightBrown,
                              ),
                            )));
                    ProductService.incrementProductToCard(product.id!)
                        .then((value) {
                      Navigator.pop(context);

                      final snackBar = SnackBar(
                        content: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Product added to cart!'),
                        ),
                        duration: const Duration(milliseconds: 2000),
                        action: SnackBarAction(
                          label: 'Go to cart',
                          onPressed: () {
                            selectedIndex = 2;
                            //Go to home page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainPage(),
                              ),
                            );
                          },
                        ),
                      );

//Go to home page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ),
                      );
                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }).onError((error, stackTrace) {
                      Navigator.pop(context);
                      // show loading circle
                      showDialog(
                          context: context,
                          builder: ((context) => Center(
                                  child: Center(
                                child: LightText(text: error.toString()),
                              ))));
                    });
                  },
                ))
          ],
        ),
      ),
    );
  }
}
