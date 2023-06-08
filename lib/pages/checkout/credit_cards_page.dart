import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tacafe/models/models.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/services/services.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class CreditCardsPage extends StatelessWidget {
  const CreditCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);

    if (userService.isLoading) return const LoadingPage();

    return Scaffold(
      appBar: DefaultAppbar(
        text: 'Credit Cards',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20, left: 20, right: 20, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                  stream: FirebaseDatabase.instance
                      .ref("users/${FirebaseAuth.instance.currentUser!.uid}")
                      .child('cards')
                      .onValue,
                  builder: (context, snap) {
                    if (snap.hasData &&
                        !snap.hasError &&
                        snap.data!.snapshot.value != null) {
                      Map<String, dynamic> cardsMap = Map<String, dynamic>.from(
                          snap.data!.snapshot.value as Map);
                      Map<String, MyCard> mycards = cardsMap.map((k, v) =>
                          MapEntry<String, MyCard>(
                              k, MyCard.fromMap(Map<String, dynamic>.from(v))));
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: mycards.length,
                          itemBuilder: (context, index) {
                            MyCard card =
                                mycards.entries.elementAt(index).value;
                            String idCard =
                                mycards.entries.elementAt(index).key;
                            return _TapContainer(
                              selected: card.active,
                              icon: Icons.credit_card_outlined,
                              text:
                                  '*** ${card.num.toString().substring(card.num.toString().length - 4)}',
                              onTap: () {
                                UserService.updateUserCards(card, idCard);
                                Navigator.pop(context);
                              },
                            );
                          });
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                _TapContainer(
                  icon: Icons.credit_card_outlined,
                  text: 'Add Credit Card',
                  onTap: () => Navigator.pushNamed(context, '/add_credit_card'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TapContainer extends StatelessWidget {
  final Function()? onTap;
  final IconData icon;
  final String text;
  final bool selected;

  const _TapContainer({
    this.onTap,
    required this.icon,
    required this.text,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 10, vertical: 5),
            child: Icon(icon), //Icons.location_on_rounded
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppTheme.grey, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    text: text,
                    fontSize: 20,
                  ),
                  selected
                      ? const Icon(
                          Icons.check,
                          size: 15,
                        )
                      : const SizedBox()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
