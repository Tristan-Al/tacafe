import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

import 'package:tacafe/services/firebase_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    List categories = [
      '☕ COFFE',
      'ALCOHOL',
      'BREAKFAST',
      'ALCOHOL FREE',
      'DESSERTS'
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    HeaderText(
                      text: 'Calle Reina Mora, 2',
                      fontSize: 15,
                      color: AppTheme.darkBrown,
                    ),
                    const Icon(
                      Icons.arrow_drop_down_rounded,
                    )
                  ],
                ),
                const Icon(Icons.phone)
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            MyTextFormField(
              controller: searchController,
              icon: Icons.search_outlined,
              borderRadius: 50,
              labelText: 'Search...',
            ),
            const SizedBox(
              height: 30,
            ),
            const HeaderText(
              text: "Categories",
              fontSize: 20,
              color: AppTheme.darkBrown,
            ),
            const SizedBox(
              height: 15,
            ),
            Wrap(
              direction: Axis.horizontal,
              spacing: 15,
              runSpacing: 10,
              children: categories
                  .map((item) => MyContainer(
                        text: item,
                        textColor: AppTheme.darkBrown,
                        borderColor: AppTheme.darkBrown,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                      ))
                  .toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              runSpacing: 10,
              children: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
                  .map((e) => GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ProductDetailPage();
                        })),
                        child: Container(
                          width: (MediaQuery.of(context).size.width / 2) - 25,
                          height: 230,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                                color: AppTheme.darkBrown, width: .5),
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
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://media-cldnry.s-nbcnews.com/image/upload/t_fit-1500w,f_auto,q_auto:best/newscms/2019_33/2203981/171026-better-coffee-boost-se-329p.jpg'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const HeaderText(
                                text: "Capuccino",
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 1),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  MyContainer(
                                    text: 'M',
                                    borderColor: AppTheme.brown,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 1),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  MyContainer(
                                    text: 'L',
                                    borderColor: AppTheme.brown,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 1),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  HeaderText(
                                    text: "3\$",
                                    color: AppTheme.darkBrown,
                                    fontSize: 20,
                                  ),
                                  Icon(
                                    Icons.add_circle_outlined,
                                    color: AppTheme.brown,
                                    size: 30,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
