import 'dart:math' as math;
import 'package:flutter/services.dart';

class AppRegex {
  static final RegExp successCode = RegExp(r'20\d');
  static final RegExp capitalLetter = RegExp(r'[A-Z0-9]');
  static final RegExp nameWhitelist = RegExp(r'[A-Za-z\-\. ]');
  static final RegExp middleNameWhitelist = RegExp(r'[A-Za-z\-]');
  static final RegExp addressWhitelist = RegExp(r'[A-Za-z0-9_,\-\./ ]');
  static final RegExp operatorWhitelist = RegExp(r'[A-Za-z0-9_,\-\./ ]');
  static final RegExp digitsOnly = RegExp(r'\d');
  static final RegExp floatNumber = RegExp(r'[\.\d]');
  static final RegExp multiSpaces = RegExp(r'  ');
  static final RegExp space = RegExp(r' ');
  static final RegExp removeDecimalZeroFormat = RegExp(r'([.]*0)(?!.*\d)');
  static final RegExp alphaNumeric = RegExp(r'[A-Za-z0-9]');
  static final RegExp alphaNumericWithSpace = RegExp(r'[A-Za-z0-9 ]');
  static final RegExp fullName = RegExp(r'[A-Za-z\-\. ]');
  static final RegExp passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^\w\s]).{8,}$');
  static final RegExp emojiRegex = RegExp(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
  static final RegExp emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
  static final RegExp passRegex = RegExp(r"""[a-zA-Z0-9!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]""");
  static final RegExp specialCharRegex = RegExp(r"""[!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]""");
  static final List<String> allAlphabets = """A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z""".split(",").toList();
  static final List<String> zeroToNineNumberList = """0,1,2,3,4,5,6,7,8,9""".split(",").toList();
  static final List<String> specCharList = r"""!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~""".split("").toList();

  static bool hasAllNecessaryField(String? text) {
    if (text == null || text.trim().length < 8 || text.trim().length > 16) {
      return false;
    }
    bool isValidPassword = true, hasCapitalAlpha = false, hasSmallAlpha = false, hasNumber = false, hasSpecialChar = false;
    for (int fIndex = 0; fIndex < text.length; fIndex++) {
      if (allAlphabets.contains(text[fIndex])) {
        hasCapitalAlpha = true;
      }
    }
    if (!hasCapitalAlpha) {
      return hasCapitalAlpha;
    }
    for (int fIndex = 0; fIndex < text.length; fIndex++) {
      if (allAlphabets.map((e) => e.toLowerCase()).toList().contains(text[fIndex])) {
        hasSmallAlpha = true;
      }
    }
    if (!hasSmallAlpha) {
      return hasSmallAlpha;
    }
    for (int fIndex = 0; fIndex < text.length; fIndex++) {
      if (zeroToNineNumberList.contains(text[fIndex])) {
        hasNumber = true;
      }
    }
    if (!hasNumber) {
      return hasNumber;
    }
    for (int fIndex = 0; fIndex < text.length; fIndex++) {
      if (specCharList.contains(text[fIndex])) {
        hasSpecialChar = true;
      }
    }
    if (!hasSpecialChar) {
      return hasSpecialChar;
    }
    return isValidPassword;
  }
}

class FilterFormatter {
  static final List<TextInputFormatter> emailFilterFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._]')),
    // FilteringTextInputFormatter.deny(RegExp(r'^_+')),
    FilteringTextInputFormatter.deny(AppRegex.emojiRegex),
    EmailInputFormatter(),
    SpaceInputFormatter(),
  ];

  static final List<TextInputFormatter> decimalInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'(^\-?\d*\.?\d*)')),
    DecimalTextInputFormatter(decimalRange: 2),
    FilteringTextInputFormatter.deny(AppRegex.emojiRegex),
    SpaceInputFormatter(),
  ];

  static final List<TextInputFormatter> passwordFieldFormatter = [
    FilteringTextInputFormatter.allow(AppRegex.passRegex),
    FilteringTextInputFormatter.deny(AppRegex.emojiRegex),
    SpaceInputFormatter(),
  ];

  static final List<TextInputFormatter> nameFieldFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z. ]')),
    SpaceInputFormatter(),
  ];

  static final List<TextInputFormatter> propertyNameFieldFormatter = [
    FilteringTextInputFormatter.deny(AppRegex.emojiRegex),
    SpaceInputFormatter(),
  ];

  static final List<TextInputFormatter> numberFieldFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    SpaceInputFormatter(),
  ];

  static final List<TextInputFormatter> otpFieldFormatter = [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  ];

  static final List<TextInputFormatter> goPinFieldFormatter = [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))];

  static final List<TextInputFormatter> cardNumberFieldFormatter = [
    FilteringTextInputFormatter.digitsOnly,
    CardNumberInputFormatter(),
    SpaceInputFormatter(),
  ];

  static final List<TextInputFormatter> cardExpiryDatFieldFormatter = [
    FilteringTextInputFormatter.digitsOnly,
    CardExpiryDateInputFormatter(),
    SpaceInputFormatter(),
  ];

  static final List<TextInputFormatter> searchFieldFormatter = [
    FilteringTextInputFormatter.allow(AppRegex.alphaNumericWithSpace),
    SpaceInputFormatter(),
  ];

  static final List<TextInputFormatter> spaceFormatter = [
    SpaceInputFormatter(),
  ];

  static final List<TextInputFormatter> startSpaceFormatter = [
    StartSpaceInputFormatter(),
  ];
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange}) : assert(decimalRange == null || decimalRange > 0);

  final int? decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;
    if (decimalRange != null) {
      String value = newValue.text;
      if (value == "00") {
        truncated = /*"0."*/ "";
        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      } else if (value.contains(".") && value.substring(value.indexOf(".") + 1).length > decimalRange!) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == "." || value == "0") {
        truncated = /*"0."*/ "";
        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }
      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

class SpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;
    String value = newValue.text;
    if (value.contains("  ")) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == " ") {
      truncated = "";
      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }
    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

class StartSpaceInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;
    String value = newValue.text;
    if (value == " ") {
      truncated = "";
      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }
    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

class EmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;
    String value = newValue.text;
    if (value.contains("@@")) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value.contains("..")) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value.contains(".@") && oldValue.selection.end == value.length - 1) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == "@") {
      truncated = "";
      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    } else if (value == ".") {
      truncated = "";
      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }
    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(" ");
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class CardExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        buffer.write("/");
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
