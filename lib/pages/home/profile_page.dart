import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/services/services.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);

    if (userService.isLoading) return const LoadingPage();

    final String userId = FirebaseAuth.instance.currentUser == null
        ? '-1'
        : FirebaseAuth.instance.currentUser!.uid;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: StreamBuilder(
            stream: FirebaseDatabase.instance.ref("users/$userId").onValue,
            builder: (context, snap) {
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data!.snapshot.value != null) {
                Map<String, dynamic> data =
                    Map<String, dynamic>.from(snap.data!.snapshot.value as Map);
                print(data);
                MyUser user = MyUser.fromMap(data);
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: HeaderText(
                            text: user.name ?? user.email,
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: user.image != null
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
                    ItemColumn(
                      text: 'Edit account',
                      icon: Icons.edit,
                      onTap: () =>
                          Navigator.pushNamed(context, '/edit_profile'),
                    ),
                    ItemColumn(
                      text: 'Orders',
                      icon: Icons.article_rounded,
                      onTap: () => Navigator.pushNamed(context, '/orders'),
                    ),
                    ItemColumn(
                      text: 'About',
                      icon: Icons.info,
                      onTap: () => Navigator.pushNamed(context, '/about'),
                    ),
                    ItemColumn(
                      text: 'Logout',
                      icon: Icons.logout_outlined,
                      onTap: () => AuthService.signUserOut(context),
                    ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
