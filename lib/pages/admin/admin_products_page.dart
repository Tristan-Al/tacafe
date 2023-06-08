import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/services/services.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    if (productService.isLoading) return const LoadingPage();

    return Scaffold(
      appBar: DefaultAppbar(text: 'Admin products'),
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
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _ItemContainer(product: products[index]);
                  },
                );
              } else {
                return ErrorTemplate(
                  assetImage: 'assets/empty-cart.png',
                  title: 'Ooops!',
                  subtitle: 'There is no products yet',
                  buttonText: 'Go home',
                  onTap: () {
                    selectedIndex = 0;
                    Navigator.pushNamed(context, '/');
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _ItemContainer extends StatelessWidget {
  final Product product;

  const _ItemContainer({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: product.image == null
                  ? const DecorationImage(
                      image: AssetImage('assets/no-image.jpg'),
                      fit: BoxFit.cover)
                  : DecorationImage(
                      image: NetworkImage(product.image!), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(
                  text: product.name,
                  fontSize: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pushNamed(
                          context, '/admin_edit_product',
                          arguments: product),
                      icon: const Icon(
                        Icons.edit,
                        color: AppTheme.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Center(
                            child: Text(
                              'Are you sure you want to delete this product?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: MyElevatedButton(
                            onPressed: () {
                              FirebaseDatabase.instance
                                  .ref("products/${product.id}")
                                  .remove();
                              Navigator.pop(context);
                            },
                            child: const NormalText(
                              text: 'Delete',
                              fontSize: 20,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
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
