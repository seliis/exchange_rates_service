import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter/material.dart";

final class Home {
  const Home();

  static List<String> currencies = dotenv.env["CURRENCIES"]?.split(",") ??
      [
        "USD",
        // "CHF",
        // "EUR",
        // "GBP",
        // "JPY",
        // "THB"
      ];

  static final controller = TextEditingController(
    text: DateTime.now().toString().substring(0, 10),
  );

  static String currency = currencies.first;

  static HomeData get data {
    return HomeData(
      currency: currency,
      date: controller.text,
    );
  }
}

final class HomeData {
  const HomeData({
    required this.currency,
    required this.date,
  });

  final String currency;
  final String date;
}
