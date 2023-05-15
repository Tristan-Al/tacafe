import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/Buttons/my_icon_button.dart';
import 'package:tacafe/widgets/widgets.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    double imgHeight = MediaQuery.of(context).size.height / 2.2;
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: double.infinity,
                height: imgHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://media-cldnry.s-nbcnews.com/image/upload/t_fit-1500w,f_auto,q_auto:best/newscms/2019_33/2203981/171026-better-coffee-boost-se-329p.jpg'),
                    fit: BoxFit.cover,
                  ),
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
                    const LightText(
                      text: 'Cappuccino',
                      color: AppTheme.white,
                      fontSize: 25,
                    ),
                    MyContainer(
                      text: '★ 4.9',
                      backgroundColor: AppTheme.brown,
                      textColor: AppTheme.white,
                      borderColor: AppTheme.brown,
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
                    HeaderText(
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    HeaderText(
                      text: 'About',
                      color: AppTheme.black,
                      fontSize: 22,
                    ),
                    const SizedBox(height: 10),
                    LightText(
                      text:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Id ipsum vivamus velit lorem amet. Tincidunt cras volutpat aliquam porttitor molestie. Netus neque, habitasse id vulputate proin cras. Neque, vel duis sit vel pellentesque tempor. A commodo arcu tortor arcu, elit. ',
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
                      children: const [
                        LightText(
                          text: 'Add to Cart',
                          fontSize: 25,
                          color: AppTheme.white,
                        ),
                        LightText(
                          text: '|    3 \$',
                          fontSize: 25,
                          color: AppTheme.white,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {},
                ))
          ],
        ),
      ),
    );
  }
}
