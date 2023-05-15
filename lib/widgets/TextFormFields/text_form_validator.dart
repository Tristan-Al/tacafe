class MyTextFormValidators {
  static String? Function(String?)? basicValidator = (value) {
    if (value!.isEmpty) {
      return 'Field required';
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
