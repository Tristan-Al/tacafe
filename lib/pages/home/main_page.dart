import 'package:flutter/material.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/theme/app_theme.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

int selectedIndex =
    0; // Index which is globally accessible throughtout your project

class _MainPageState extends State<MainPage> {
  static final List<Widget> _pages = <Widget>[
    HomePage(),
    // FavouritePage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 15),
        decoration: const BoxDecoration(
          color: Color(0xFFF8F7FA),
          border: Border(
            top: BorderSide(color: Color.fromARGB(50, 132, 96, 70)),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.favorite_border_rounded),
            //   label: 'Favourite',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart_rounded),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
          currentIndex: selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
