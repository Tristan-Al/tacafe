class MyTextFormValidators {
  static String? Function(String?)? numberValidator = (value) {
    if (value!.isEmpty) {
      return 'Field required';
    }
    final RegExp nameRegExp = RegExp(r'^[0-9]+$');

    if (!nameRegExp.hasMatch(value)) {
      return 'Invalid number field';
    }
    return null;
  };

  static String? Function(String?)? doubleValidator = (value) {
    if (value!.isEmpty) {
      return 'Field required';
    }
    final RegExp nameRegExp = RegExp(r'^[0-9]+(\.[0-9]+)?$');

    if (!nameRegExp.hasMatch(value)) {
      return 'Invalid double field';
    }
    return null;
  };

  static String? Function(String?)? stringValidator = (value) {
    if (value!.isEmpty) {
      return 'Field required';
    }
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s.,-]+$');

    if (!nameRegExp.hasMatch(value)) {
      return 'Invalid field';
    }
    return null;
  };

  static String? Function(String?)? addressValidator = (value) {
    if (value!.isEmpty) {
      return 'Address required';
    }
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z0-9\s.,#-]+$');

    if (!nameRegExp.hasMatch(value)) {
      return 'Invalid address';
    }
    return null;
  };

  static String? Function(String?)? emailValidator = (value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(value ?? '')
        ? null
        : 'Please enter a valid email address';
  };

  static String? Function(String?)? passwordValidator = (value) {
    if (value!.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be 6 or more characters';
    }
    return null;
  };
}
