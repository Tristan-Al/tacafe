import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HFTemplate(body: _Body());
  }
}

class _Body extends StatefulWidget {
  const _Body({super.key});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final myFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  Future passwordReset() async {
    // dimiss keyboard
    FocusScope.of(context).unfocus();

    // show loading circle
    showDialog(
      context: context,
      builder: ((context) => const Center(
            child: CircularProgressIndicator(
              color: AppTheme.lightBrown,
            ),
          )),
    );

    if (!myFormKey.currentState!.validate()) {
      //removes loading circle
      Navigator.pop(context);
    } else {
      //try to send email
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text.trim());
        Navigator.pop(context);
        _showErrorMessage('Password reset link sent! Check your email');
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        switch (e.code) {
          case 'user-not-found':
            _showErrorMessage('There is no user registered with this email');
            break;
          case 'invalid-email':
            _showErrorMessage('Please enter a valid email');
            break;
          case 'missing-email':
            _showErrorMessage('Missing email!');
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
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 80, top: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                  alignment: Alignment.centerRight,
                  onPressed: () => {Navigator.pop(context)},
                  icon: const Icon(Icons.arrow_back_ios,
                      size: 28, color: AppTheme.lightBrown),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            width: 180,
            height: 180,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/saitama.png'),
              backgroundColor: AppTheme.lightBrown,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const HeaderText(
                  text: 'Forgot Password?',
                  fontSize: 30,
                ),
                const SizedBox(
                  height: 10,
                ),
                const LightText(
                  text:
                      'Enter your Email and we will send you a password reset link',
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: myFormKey,
                    child: Column(children: [
                      MyTextField(
                        controller: emailController,
                        validator: MyTextFormValidators.emailValidator,
                        labelText: 'Email',
                      ),
                    ])),
                const SizedBox(
                  height: 30,
                ),
                MyElevatedButton(
                  onPressed: passwordReset,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(10),
                  child: const LightText(
                    text: 'Reset Password',
                    color: AppTheme.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
