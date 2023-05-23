import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

import 'package:tacafe/services/services.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String _selectedCategory = '';

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
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
              FutureBuilder(
                  future: ProductService.getCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Wrap(
                        direction: Axis.horizontal,
                        spacing: 15,
                        runSpacing: 10,
                        children: snapshot.data!
                            .map((item) => MyContainer(
                                  text: item,
                                  textColor: _selectedCategory == item
                                      ? AppTheme.white
                                      : AppTheme.darkBrown,
                                  borderColor: AppTheme.darkBrown,
                                  backgroundColor: _selectedCategory == item
                                      ? AppTheme.darkBrown
                                      : AppTheme.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  onTap: () {
                                    _selectedCategory == item
                                        ? setState(() {
                                            _selectedCategory = '';
                                          })
                                        : setState(() {
                                            _selectedCategory = item;
                                          });
                                  },
                                ))
                            .toList(),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),

              // Wrap(
              //   direction: Axis.horizontal,
              //   spacing: 15,
              //   runSpacing: 10,
              //   children: categories
              //       .map((item) => MyContainer(
              //             text: item,
              //             textColor: AppTheme.darkBrown,
              //             borderColor: AppTheme.darkBrown,
              //             padding: const EdgeInsets.symmetric(
              //                 vertical: 10, horizontal: 10),
              //           ))
              //       .toList(),
              // ),
              // Wrap(
              //   direction: Axis.horizontal,
              //   spacing: 10,
              //   runSpacing: 10,
              //   children: [1]
              //       .map((e) => ProductCard(
              //             product: null,
              //           ))
              //       .toList(),
              // ),
              FutureBuilder(
                future: _selectedCategory.isEmpty
                    ? ProductService.getProducts()
                    : ProductService.getProductswithCategory(_selectedCategory),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length == 0) {
                      return ErrorTemplate(
                        assetImage: 'assets/results-not-found.png',
                        title: 'We didn\'t find a match',
                        subtitle: 'Try searching for something else instead',
                        buttonText: 'Go to home',
                        onTap: () {
                          _selectedCategory = '';
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
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisExtent: 230,
                            maxCrossAxisExtent: 200,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final Product product = snapshot.data![index];

                            return ProductCard(product: product);
                          },
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
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
