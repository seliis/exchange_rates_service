final class CurrencyBasicData {
  const CurrencyBasicData({
    required this.currencyCode,
    required this.currencyName,
  });

  final String currencyCode;
  final String currencyName;

  factory CurrencyBasicData.fromJson(Map<String, dynamic> json) {
    return CurrencyBasicData(
      currencyCode: json["currency_code"] as String,
      currencyName: json["currency_name"] as String,
    );
  }
}

final class Currency {
  const Currency({
    required this.curreencyCode,
    required this.date,
    required this.rate,
  });

  final String curreencyCode;
  final String date;
  final double rate;

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      curreencyCode: json["currency_code"] as String,
      date: json["date"] as String,
      rate: json["rate"] as double,
    );
  }
}
