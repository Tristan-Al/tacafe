import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/services/services.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final myFormKey = GlobalKey<FormState>();

    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    final userService = Provider.of<UserService>(context);

    if (userService.isLoading) return const LoadingPage();

    MyUser user = UserService.getUser(FirebaseAuth.instance.currentUser!.uid);

    nameController.text = user.name ?? '';
    phoneController.text = user.phone ?? '';
    addressController.text = user.address ?? '';
    return Scaffold(
      appBar: DefaultAppbar(text: 'Account Info'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: user.image != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.image!),
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MyTextFormField(
                        controller: nameController,
                        labelText: 'Name',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextFormField(
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
                      MyTextFormField(
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
                      user.name = nameController.text.trim();
                      user.phone = phoneController.text.trim();
                      user.address = addressController.text.trim();

                      FirebaseDatabase.instance.ref("users/${user.id}").update({
                        'name': user.name,
                        'phone': user.phone,
                        'address': user.address,
                      });

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

      // child: FutureBuilder(
      //   future: UserService.getUser(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return const Center(
      //         child: HeaderText(text: 'Something went wrong'),
      //       );
      //     }
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       final MyUser user = MyUser.fromJson(
      //           snapshot.data!.data() as Map<String, dynamic?>);
      //       nameController.text = user.name;
      //       phoneController.text = user.phone ?? '';
      //       addressController.text = user.address;

      //       return
      //     }

      //     return const Center(child: CircularProgressIndicator());
      //   },
      // ),
    );
  }
}
