final class ExchangeData {
  const ExchangeData({
    required this.currency,
    required this.date,
    required this.rates,
    required this.amosRates,
  });

  final String currency;
  final String date;
  final double rates;
  final double amosRates;

  factory ExchangeData.fromJson(Map<String, dynamic> json) {
    return ExchangeData(
      currency: json["currency"] as String,
      date: json["date"] as String,
      rates: json["rates"] as double,
      amosRates: json["amos_rates"] as double,
    );
  }
}
