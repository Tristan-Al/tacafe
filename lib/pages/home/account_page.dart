import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/main.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/services/services.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final firebaseUser = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();

    // Restart App:
    // Remove any route in the stack
    Navigator.of(context).popUntil((route) => false);

    // Add the first route
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: UserService.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: HeaderText(text: 'Something went wrong'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              print(
                  'ACCOUNT PAGE: user is empty?: ${snapshot.data.data() == null}');
              if (snapshot.data.data() == null) {
                Future.delayed(Duration(seconds: 2));
              }
              final MyUser user = MyUser.fromJson(
                  snapshot.data!.data() as Map<String, dynamic?>);
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: HeaderText(
                            text: user.name.isEmpty ? user.email : user.name,
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: user.image!.isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(user.image!),
                                  backgroundColor: AppTheme.lightBrown,
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      const AssetImage('assets/no-profile.png'),
                                  backgroundColor: Colors.grey[300],
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    _ItemColumn(
                      text: 'Edit account',
                      icon: Icons.edit,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      ),
                    ),
                    _ItemColumn(
                      text: 'Orders',
                      icon: Icons.article_rounded,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      ),
                    ),
                    _ItemColumn(
                      text: 'Logout',
                      icon: Icons.logout_outlined,
                      onTap: () => signUserOut(),
                    ),
                  ],
                ),
              );
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class _ItemColumn extends StatelessWidget {
  const _ItemColumn({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
  });

  final String text;
  final IconData? icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(color: AppTheme.grey, width: .5),
        )),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 20,
            ),
            NormalText(
              text: text,
              fontSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}
