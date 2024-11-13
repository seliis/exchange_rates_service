import "package:app/entities/.index.dart" as entities;
import "package:app/infra/.index.dart" as infra;

final class CurrencyRepository {
  Future<List<String>> getCurrencyCodes() async {
    final response = await infra.Http.request<List<Map<String, dynamic>>>(
      infra.HttpMethod.get,
      "/currencyCodes",
    );

    if (response.isSuccess) {
      return response.data.map((e) => entities.CurrencyBasicData.fromJson(e)).map((e) => e.currencyCode).toList();
    } else {
      throw Exception(response.errorMessage);
    }
  }

  Future<entities.Currency> getCurrency({
    required String currencyCode,
    required String date,
  }) async {
    final response = await infra.Http.request<Map<String, dynamic>>(
      infra.HttpMethod.get,
      "/currency/$currencyCode?date=$date",
    );

    if (response.isSuccess) {
      return entities.Currency.fromJson(response.data);
    } else {
      throw Exception(response.errorMessage);
    }
  }
}
