import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/services/services.dart';
import 'package:tacafe/widgets/widgets.dart';
import 'package:tacafe/theme/app_theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return HFTemplate( body: _Body() );
  }
}



class _Body extends StatefulWidget {
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final myFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // dimiss keyboard
    FocusScope.of(context).unfocus();

    // show loading circle
    showDialog(
      context: context, 
      builder: ((context) => const Center(child: CircularProgressIndicator( color: AppTheme.lightBrown,),))
    );

    if (!myFormKey.currentState!.validate()) { 
      //removes loading circle
      Navigator.pop(context);
    } else {
      //try to sign in
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text,
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        switch (e.code) {
          case 'user-not-found':
            _showErrorMessage('There is no user registered with this email');
            break;
          case 'invalid-email':
            _showErrorMessage('Please enter a valid email');
            break;
          case 'wrong-password':
            _showErrorMessage('Incorrect password, try again!');
            break;
          case 'user-disabled':
            _showErrorMessage('USER BANNED!');
            break;
          default:
            break;
        }
      }
    }
  }

  void _showErrorMessage( String message ) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 80, top: 150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HeaderText(text: 'Welcome back!',),
              LightText(text: 'Login to your account.',),
            ],
          ),
          Form(
            key: myFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MyTextFormField(
                  controller: emailController,
                  validator: MyTextFormValidators.emailValidator,
                  labelText: 'Email', 
                ),
                const SizedBox(height: 20,),
                MyTextFormField(
                  controller: passwordController,
                  validator: MyTextFormValidators.passwordValidator,
                  labelText: 'Password', 
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10,),
                GestureDetector(
                  child: const LightText(text: 'Forgot password?', fontSize: 15, color: AppTheme.brown,),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) { return ForgotPasswordPage();}));
                  },
                ),
              ],
            ),
          ),
          MyElevatedButton(
            onPressed: signUserIn,
            width: double.infinity, 
            borderRadius: BorderRadius.circular(10),
            child: const LightText(text: 'Sign In', color: AppTheme.white,),
          ),
          Row(
            children: const [
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: AppTheme.grey,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: LightText(text: 'Or continue with', fontSize: 15,),
              ),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: AppTheme.grey,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SquareCard(
                imagePath: 'assets/google.png',
                onTap: () => AuthService().signInWithGoogle(),
              ),
              const SizedBox( width: 10,),
              SquareCard(
                imagePath: 'assets/apple.png',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) { return const ErrorPage();})),
              ),
            ],
          ),
          Row(
            children: [
              const LightText(text: 'You don\'t have an account yet? ', fontSize: 15,),
              GestureDetector(
                child: const Text("Register", style: TextStyle( color: AppTheme.brown, fontWeight: FontWeight.bold),),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) { return RegisterPage();})),
              )
            ],
          )
        ],
      ),
    );
  }
}