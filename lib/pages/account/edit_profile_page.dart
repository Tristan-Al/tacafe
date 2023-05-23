import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/services/services.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/Buttons/my_icon_button.dart';
import 'package:tacafe/widgets/widgets.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final myFormKey = GlobalKey<FormState>();

    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        leadingWidth: 100,
        toolbarHeight: 70,
        title: const HeaderText(
          text: 'Account info',
          fontSize: 22,
        ),
        backgroundColor: AppTheme.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.brown, size: 30),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: UserService.getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: HeaderText(text: 'Something went wrong'),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final MyUser user = MyUser.fromJson(
                  snapshot.data!.data() as Map<String, dynamic?>);
              nameController.text = user.name;
              phoneController.text = user.phone ?? '';
              addressController.text = user.address;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: user.image!.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(user.image!),
                                backgroundColor: Colors.grey[300],
                                child: MyIconButton(
                                  icon: Icons.edit,
                                  onPressed: () {},
                                  backgroundColor: AppTheme.grey,
                                  iconColor: Colors.black26,
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
                                    backgroundColor: AppTheme.grey,
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _TextFormField(
                              controller: nameController,
                              labelText: 'Name',
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            _TextFormField(
                              controller: phoneController,
                              labelText: 'Phone',
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.length < 9) {
                                  return 'This doen\'t look like a phone number.';
                                } else if (value.length > 9) {
                                  return 'This doesn\'t look like a phone number.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            _TextFormField(
                              controller: addressController,
                              labelText: 'Address',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      MyElevatedButton(
                        onPressed: () {
                          // show loading circle
                          showDialog(
                              context: context,
                              builder: ((context) => const Center(
                                    child: CircularProgressIndicator(
                                      color: AppTheme.lightBrown,
                                    ),
                                  )));
                          if (!myFormKey.currentState!.validate()) {
                            //removes loading circle
                            Navigator.pop(context);
                          } else {
                            user.id = FirebaseAuth.instance.currentUser!.uid;
                            user.name = nameController.text.trim();
                            user.phone = phoneController.text.trim();
                            user.address = addressController.text.trim();
                            UserService.updateUser(user).then((value) {
                              Navigator.pop(context);

                              final snackBar = SnackBar(
                                content: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text('User updated!'),
                                ),
                                duration: const Duration(milliseconds: 2000),
                                action: SnackBarAction(
                                  label: 'Go to home',
                                  onPressed: () {
                                    selectedIndex = 0;
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

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }).onError((error, stackTrace) {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: ((context) => Center(
                                          child: Center(
                                        child:
                                            LightText(text: error.toString()),
                                      ))));
                            });
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
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _TextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String? Function(String?)? validator;

  const _TextFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.keyboardType,
    this.obscureText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.grey, width: .3)),
      ),
      child: TextFormField(
        autofocus: false,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
