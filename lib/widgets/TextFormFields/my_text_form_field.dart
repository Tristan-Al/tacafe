import 'package:flutter/material.dart';
import 'package:tacafe/theme/app_theme.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String? Function(String?)? validator;

  const MyTextFormField({
    super.key,
    required this.controller,
    this.labelText,
    this.keyboardType,
    this.obscureText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.grey, width: .3)),
      ),
      child: TextFormField(
        autofocus: false,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
