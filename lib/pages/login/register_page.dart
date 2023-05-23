import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/pages/pages.dart';
import 'package:tacafe/services/services.dart';
import 'package:tacafe/widgets/widgets.dart';
import 'package:tacafe/theme/app_theme.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return HFTemplate(body: _Body());
  }
}

class _Body extends StatefulWidget {
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final myFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user up method
  void signUserUp() async {
    // dimiss keyboard
    FocusScope.of(context).unfocus();
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
      //try to sign up
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
            .then((result) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(result.user!.uid)
              .set({
            'email': emailController.text.trim(),
            'name': nameController.text.trim(),
            'address': addressController.text.trim(),
            'cart': [],
          });
        });

        Navigator.pop(context);
        //Go to home page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        switch (e.code) {
          case 'email-already-in-use':
            _showErrorMessage('The email address already in use');
            break;
          case 'invalid-email':
            _showErrorMessage('Please enter a valid email');
            break;
          case 'operation-not-allowed':
            _showErrorMessage('USER NOT ALLOWED!');
            break;
          case 'weak-password':
            _showErrorMessage('Password must be 6 or more characters');
            break;
          default:
            break;
        }
      }
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 60, top: 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              HeaderText(
                text: 'Sign Up',
              ),
              LightText(
                text: 'Let\'s create an account!',
              ),
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
                const SizedBox(
                  height: 15,
                ),
                MyTextFormField(
                  controller: nameController,
                  validator: MyTextFormValidators.basicValidator,
                  labelText: 'Name',
                ),
                const SizedBox(
                  height: 15,
                ),
                MyTextFormField(
                  controller: addressController,
                  validator: MyTextFormValidators.basicValidator,
                  labelText: 'Address',
                ),
                const SizedBox(
                  height: 15,
                ),
                MyTextFormField(
                  controller: passwordController,
                  validator: MyTextFormValidators.passwordValidator,
                  labelText: 'Password',
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 15,
                ),
                MyTextFormField(
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Confirm password is required';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords don\'t match';
                    }
                    return null;
                  },
                  labelText: 'Confirm Password',
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
          MyElevatedButton(
            onPressed: signUserUp,
            width: double.infinity,
            borderRadius: BorderRadius.circular(10),
            child: const LightText(
              text: 'Sign Up',
              color: AppTheme.white,
            ),
          ),
          Row(
            children: [
              const LightText(
                text: 'Already have an account? ',
                fontSize: 15,
              ),
              GestureDetector(
                child: const Text(
                  "Login",
                  style: TextStyle(
                      color: AppTheme.darkBrown, fontWeight: FontWeight.bold),
                ),
                onTap: () => Navigator.pop(context),
              )
            ],
          )
        ],
      ),
    );
  }
}
