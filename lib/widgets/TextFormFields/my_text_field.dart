
import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final IconData? icon;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String? Function(String?)? validator;

  const MyTextFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.icon,
    this.keyboardType,
    this.obscureText, 
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: Icon(icon),
      ),
    );
  }
}