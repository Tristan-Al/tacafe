import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/services/services.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String _selectedCategory = '';
MyUser currentUser = UserService.getUser(
    FirebaseAuth.instance.currentUser != null
        ? FirebaseAuth.instance.currentUser!.uid
        : '');

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    final userService = Provider.of<UserService>(context);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.brown,
              ),
              child: Center(
                  child: NormalText(
                text: 'Admin area',
                color: AppTheme.white,
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ItemColumn(
                text: 'Products',
                icon: Icons.fastfood_rounded,
                color: AppTheme.brown,
                onTap: () => Navigator.pushNamed(context, '/admin_products'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ItemColumn(
                text: 'Exit',
                icon: Icons.exit_to_app_rounded,
                color: AppTheme.brown,
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 15),
          child: StreamBuilder(
            stream: FirebaseDatabase.instance.ref("products").onValue,
            builder: (context, snap) {
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data!.snapshot.value != null) {
                Map<String, dynamic> data =
                    Map<String, dynamic>.from(snap.data!.snapshot.value as Map);
                List<Product> products = [];

                data.forEach(
                  (key, value) {
                    Product tempProduct =
                        Product.fromMap(Map<String, dynamic>.from(value));
                    tempProduct.id = key;
                    products.add(tempProduct);
                  },
                );

                List categories = ProductService.getCategories(products);
                // print('HOME PAGE: All categories: $categories, \n All Products: $products \n Selected category: $_selectedCategory');
                if (_selectedCategory.isNotEmpty) {
                  products = ProductService.getProductsOfCategory(
                      products, _selectedCategory);
                }

                // print('CURRENT USER BEFORE: $currentUser');
                //Set current user
                currentUser = UserService.getUser(
                    FirebaseAuth.instance.currentUser != null
                        ? FirebaseAuth.instance.currentUser!.uid
                        : '');
                // print('CURRENT USER AFTER: $currentUser');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            currentUser.isAdmin()
                                ? IconButton(
                                    icon: const Icon(Icons.settings),
                                    onPressed: () =>
                                        Scaffold.of(context).openDrawer(),
                                  )
                                : const SizedBox(
                                    width: 0,
                                  ),
                            const HeaderText(
                              text: 'TACafe',
                              fontSize: 15,
                              color: AppTheme.darkBrown,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.phone),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Center(
                                child: HeaderText(
                                  text: 'Need support?',
                                  fontSize: 20,
                                ),
                              ),
                              content: MyElevatedButton(
                                onPressed: () =>
                                    launchUrl(Uri.parse('tel:+34 638707471')),
                                child: const NormalText(
                                  text: 'Call us',
                                  fontSize: 20,
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => showSearch(
                          context: context,
                          delegate: MySearchDelegate(products)),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.brown, width: 1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: const [
                            SizedBox(
                              width: 15,
                            ),
                            Icon(
                              Icons.search,
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            NormalText(
                              text: 'Search',
                              fontSize: 20,
                              color: AppTheme.darkBrown,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // MyTextField(
                    //   controller: searchController,
                    //   icon: Icons.search_outlined,
                    //   borderRadius: 50,
                    //   labelText: 'Search...',
                    // ),
                    const SizedBox(
                      height: 20,
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
                      children: categories.map((item) {
                        return MyContainer(
                          text: item,
                          textColor: _selectedCategory == item
                              ? AppTheme.white
                              : AppTheme.darkBrown,
                          backgroundColor: _selectedCategory == item
                              ? AppTheme.darkBrown
                              : AppTheme.white,
                          borderColor: AppTheme.darkBrown,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          onTap: () {
                            _selectedCategory == item
                                ? setState(() {
                                    _selectedCategory = '';
                                  })
                                : setState(() {
                                    _selectedCategory = item;
                                  });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 10,
                      runSpacing: 10,
                      children: products
                          .map((e) => ProductCard(
                                product: e,
                              ))
                          .toList(),
                    ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  final List<Product> products;

  MySearchDelegate(this.products);
  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            query.isEmpty ? close(context, null) : query = '';
          },
          icon: const Icon(Icons.clear),
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_ios_rounded),
      );

  @override
  Widget buildResults(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 10,
            runSpacing: 10,
            children: products
                    .where((product) => product.name
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .isEmpty
                ? [
                    ErrorTemplate(
                      assetImage: 'assets/results-not-found.png',
                      title: 'No results found',
                      subtitle:
                          'We couldn\'t find what you searched for.\nTry search again',
                      buttonText: 'Search again',
                      onTap: () => showSearch(
                          context: context,
                          delegate: MySearchDelegate(products)),
                    )
                  ]
                : products
                    .where((product) => product.name
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .map((e) => ProductCard(
                          product: e,
                        ))
                    .toList(),
          ),
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    // Build suggestions with Products Name
    List<String> suggestions =
        products.map((product) => product.name).toList().where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    // Show List of products names
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: NormalText(
            text: suggestions[index],
            fontSize: 15,
          ),
          onTap: () => Navigator.pushNamed(context, '/product_detail',
              arguments: products[index]),
        );
      },
    );
  }
}
