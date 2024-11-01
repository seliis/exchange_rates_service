import "package:flutter/material.dart";
import "package:flutter/services.dart";

final class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(context) {
    return TextField(
      decoration: const InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(),
        helperText: "e.g.; 19910314",
        labelText: "Date",
      ),
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
        _DateInputFormatter(),
      ],
    );
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue _,
    TextEditingValue value,
  ) {
    final text = value.text;

    if (text.length == 8) {
      final year = int.tryParse(text.substring(0, 4));
      final month = int.tryParse(text.substring(4, 6));
      final day = int.tryParse(text.substring(6, 8));

      if (year != null && month != null && day != null) {
        try {
          final date = DateTime(year, month, day);
          final str = "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
          return value.copyWith(
            text: str,
            selection: TextSelection.collapsed(
              offset: str.length,
            ),
          );
        } catch (e) {
          // Invalid date
        }
      }
    }

    return value;
  }
}
