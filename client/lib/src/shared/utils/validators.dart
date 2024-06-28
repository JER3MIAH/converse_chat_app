class Validator {
  static String? password(String? value, {String message = 'Enter password'}) {
    if (value == null || value.isEmpty) {
      return message;
    } else if (value.length < 8) {
      return 'Password should be atleast 8 characters long';
    }
    //  else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%\^&\*])')
    //     .hasMatch(value)) {
    //   return 'Password should contain at least one special character,a number and a capital letter';
    // }
    else {
      return null;
    }
  }

  static String? confrimPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Enter confrim password";
    } else if (value != password) {
      return "Passwords do not  match";
    } else {
      return null;
    }
  }

  static String? emptyField(String? value) {
    return null;
  }

  static String? phone(String? value, {String message = 'Enter phone number'}) {
    if (value!.isEmpty) {
      return "Field cannot be empty";
    } else if (value.length > 9 &&
        RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
            .hasMatch(value)) {
      return null;
    } else {
      return 'Enter a valid phone number';
    }
  }

  static String? pin(
    String? value,
  ) {
    if (value!.isEmpty) {
      return 'Field can not be empty';
    } else if (value.length > 4) {
      return 'Pin must be 4';
    }
    return null;
  }

  static String? nonEmptyField(
    String? value, {
    String message = 'Field cannot be empty',
  }) {
    if (value!.isEmpty) {
      return message;
    } else {
      return null;
    }
  }

  static String? emailValidator(String? value, {bool optional = false}) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regex = RegExp(pattern);
    if (value!.isEmpty && !optional) {
      return 'Field cannot be blank';
    } else if (value.isEmpty && optional) {
      return null;
    } else if (!regex.hasMatch(value.trim())) {
      return 'Enter valid email address';
    }
    return null;
  }

  String parseUnprocessedEntityError(dynamic map) {
    return (map as Map).values.join('\n');
  }

  static String? validateBankAccountNumber(String? input) {
    if (input == null || input.isEmpty) {
      return 'Field is required';
    }

    if (isNumber(input) == false) {
      return 'Invalid bank account number';
    }

    return length(
      input,
      length: 10,
      message: 'Invalid Bank Account Number (NUBAN)',
    );
  }

  static String? emailOrPhoneNumberValidator(String? value) {
    if (value!.isEmpty) {
      return 'Field cannot be blank';
    } else if (emailValidator(value) == null ||
        validatePhoneNumber(value) == null) {
      return null;
    } else {
      return "Not a valid phone number or email";
    }
  }

  static String? validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      return "Field cannot be empty";
    } else if (value.length > 9 &&
        RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
            .hasMatch(value)) {
      return null;
    } else {
      return 'Enter a valid phone number';
    }
  }

  static String? validateNIN(String? value) {
    if (value!.isEmpty) {
      return "Field cannot be empty";
    } else if (value.length == 11 &&
        RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
            .hasMatch(value)) {
      return null;
    } else {
      return 'Enter a valid NIN';
    }
  }

  static String? length(String input, {required int length, String? message}) {
    if (input.length != length) {
      return message ?? 'Should be $length characters';
    }
    return null;
  }

  static bool isNumber(String input) {
    if (input.isEmpty) {
      return false;
    }
    return double.tryParse(input) != null;
  }
}
