import 'package:flutter/services.dart';

class IDInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Prevent deletion of "UGR/"
    if (!newValue.text.startsWith("UGR/")) {
      return oldValue; // Revert to previous value
    }

    // Extract only numeric characters after "UGR/"
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length > 8) {
      text = text.substring(0, 8); // Limit total digits to 8 (6 + 2)
    }

    String formatted = "UGR/";

    if (text.length > 6) {
      formatted += "${text.substring(0, 6)}/"; // Add first 6 digits and a slash
      formatted += text.substring(6); // Add last 2 digits if available
    } else {
      formatted += text; // Just add whatever digits are entered
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.fromPosition(
        TextPosition(offset: formatted.length),
      ),
    );
  }
}
