import "package:flutter/material.dart";

final class Home {
  const Home();

  static String selectedCurrencyCode = "USD";

  static final controller = TextEditingController(
    text: DateTime.now().toString().substring(0, 10),
  );
}
