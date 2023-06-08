import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/services/services.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => UserService()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TA Cafe',
      navigatorKey: GlobalKey<NavigatorState>(),
      initialRoute: '/auth', // AuthPage(),
      theme: AppTheme.lightTheme,
      routes: {
        '/auth': (context) => const AuthPage(),
        /* Account ------------------------------- */
        '/edit_profile': (context) => const EditProfilePage(),
        '/about': (context) => const AboutPage(),
        /* Admin ------------------------------- */
        '/admin_products': (context) => const AdminProductsPage(),
        '/admin_edit_product': (context) => const AdminEditProductPage(),
        /* Checkout ------------------------------- */
        '/add_credit_card': (context) => AddCreditCardPage(),
        '/checkout': (context) => const CheckoutPage(),
        '/credit_cards': (context) => const CreditCardsPage(),
        /* Home ------------------------------- */
        '/cart': (context) => const CartPage(),
        '/home': (context) => const HomePage(),
        '/': (context) => const MainPage(),
        '/profile': (context) => const ProfilePage(),
        /* Login ------------------------------- */
        '/forgot_password': (context) => const ForgotPasswordPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        /* Order ------------------------------- */
        '/thanks_order': (context) => const ThanksOrderPage(),
        '/orders': (context) => const OrdersPage(),
        /* Product ------------------------------- */
        '/product_detail': (context) => const ProductDetailPage(),
        /* General ------------------------------- */
        '/app_state': (context) => const AppState(),
        '/error': (context) => const ErrorPage(),
      },
    );
  }
}
