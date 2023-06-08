import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class AdminEditProductPage extends StatelessWidget {
  const AdminEditProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    final myFormKey = GlobalKey<FormState>();

    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();
    final imageController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    nameController.text = product.name;
    descriptionController.text = product.description;
    categoryController.text = product.category;
    imageController.text = product.image ?? '';
    priceController.text = product.price.toString();
    stockController.text = product.stock.toString();

    return Scaffold(
      appBar: DefaultAppbar(text: 'Edit product'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: product.image != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(product.image!),
                          backgroundColor: Colors.grey[300],
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: MyIconButton(
                              icon: Icons.edit,
                              onPressed: () {},
                              backgroundColor:
                                  Colors.grey.shade300.withOpacity(.5),
                              iconColor: Colors.black26,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage:
                              const AssetImage('assets/no-profile.png'),
                          backgroundColor: Colors.grey[300],
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: MyIconButton(
                              icon: Icons.edit,
                              onPressed: () {},
                              backgroundColor:
                                  Colors.grey.shade300.withOpacity(.5),
                              iconColor: Colors.black26,
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: myFormKey,
                  child: Column(
                    children: [
                      MyTextFormField(
                        controller: nameController,
                        labelText: 'Name',
                        validator: MyTextFormValidators.stringValidator,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextFormField(
                        controller: descriptionController,
                        labelText: 'Description',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextFormField(
                        controller: imageController,
                        labelText: 'Image URL',
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextFormField(
                        controller: categoryController,
                        labelText: 'Category',
                        validator: MyTextFormValidators.stringValidator,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextFormField(
                        controller: priceController,
                        labelText: 'Price',
                        validator: MyTextFormValidators.doubleValidator,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextFormField(
                        controller: stockController,
                        labelText: 'Stock',
                        validator: MyTextFormValidators.numberValidator,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                MyElevatedButton(
                  onPressed: () {
                    if (myFormKey.currentState!.validate()) {
                      product.name = nameController.text.trim();
                      product.description = descriptionController.text.trim();
                      product.image = imageController.text.trim();
                      product.category = categoryController.text.trim();
                      product.price = double.parse(priceController.text.trim());
                      product.stock = int.parse(stockController.text.trim());

                      FirebaseDatabase.instance
                          .ref("products/${product.id}")
                          .update(product.toMap());

                      Navigator.pop(context);
                      final snackBar = SnackBar(
                        content: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Product updated!'),
                        ),
                        duration: const Duration(milliseconds: 2000),
                        action: SnackBarAction(
                          label: 'Go to home',
                          onPressed: () {
                            selectedIndex = 0;
                            //Go to home page
                            Navigator.pushNamed(context, '/');
                          },
                        ),
                      );

                      // Find the ScaffoldMessenger in the widget tree
                      // and use it to show a SnackBar.
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(10),
                  child: const LightText(
                    text: 'Save',
                    color: AppTheme.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
