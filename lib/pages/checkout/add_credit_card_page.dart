import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tacafe/models/user.dart';
import 'package:tacafe/services/services.dart';
import 'package:tacafe/theme/app_theme.dart';
import 'package:tacafe/widgets/widgets.dart';

class AddCreditCardPage extends StatelessWidget {
  AddCreditCardPage({super.key});

  final myFormKey = GlobalKey<FormState>();

  final numController = TextEditingController();
  final nameController = TextEditingController();
  final expController = TextEditingController();
  final cvvController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppbar(
        text: 'Add Credit Card',
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50, top: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: myFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MyTextField(
                    controller: numController,
                    validator: (value) {
                      if (value!.length < 19) {
                        return 'This doen\'t look like a card number.';
                      } else if (value.length > 19) {
                        return 'This doesn\'t look like a card number.';
                      }
                      final RegExp nameRegExp = RegExp(r'^[0-9\s]+$');

                      if (!nameRegExp.hasMatch(value)) {
                        return 'Invalid field';
                      }
                      return null;
                    },
                    labelText: 'Number',
                    hintText: 'xxxx xxxx xxxx xxxx',
                    inputFormatters: [
                      _CardNumberFormatter(),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    controller: nameController,
                    validator: MyTextFormValidators.stringValidator,
                    labelText: 'Card Holder',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: MyTextField(
                          controller: expController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required Field";
                            } else if (value.length < 5) {
                              return 'Invalid Date';
                            }
                            return null;
                          },
                          labelText: 'Expired Date',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d{0,2}\/?\d{0,2}$')),
                            _DateValidator(),
                          ],
                          hintText: 'MM/AA',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 5,
                        child: MyTextField(
                          controller: cvvController,
                          validator: (value) {
                            final RegExp nameRegExp = RegExp(r'^\d{3}$');

                            if (!nameRegExp.hasMatch(value!)) {
                              return 'It does\'nt look like a CVV';
                            }
                            return null;
                          },
                          labelText: 'CVV',
                          hintText: 'xxx',
                          obscureText: true,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MyElevatedButton(
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                if (myFormKey.currentState!.validate()) {
                  UserService.updateUserCards(
                      MyCard(
                        cvv: cvvController.text,
                        exp: expController.text,
                        num: numController.text,
                        active: true,
                        name: nameController.text,
                      ),
                      '');
                  Navigator.pop(context);
                }
              },
              width: double.infinity,
              borderRadius: BorderRadius.circular(10),
              child: const LightText(
                text: 'Add Card',
                color: AppTheme.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateValidator extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (newText.length == 2 && !newText.endsWith('/')) {
      newText += '/';
    }
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  bool isValidTextInput(String text) {
    try {
      DateTime expiryDate = DateTime.parse('01/$text');

      return expiryDate.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    newText = newText.replaceAll(' ', '');

    if (newText.length >= 4 && newText.length < 8) {
      newText = '${newText.substring(0, 4)} ${newText.substring(4)}';
    } else if (newText.length >= 8 && newText.length < 12) {
      newText =
          '${newText.substring(0, 4)} ${newText.substring(4, 8)} ${newText.substring(8)}';
    } else if (newText.length >= 12 && newText.length < 16) {
      newText =
          '${newText.substring(0, 4)} ${newText.substring(4, 8)} ${newText.substring(8, 12)} ${newText.substring(12)}';
    } else if (newText.length >= 16 && newText.length < 19) {
      newText =
          '${newText.substring(0, 4)} ${newText.substring(4, 8)} ${newText.substring(8, 12)} ${newText.substring(12)}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
