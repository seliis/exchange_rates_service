import "package:app/entities/.index.dart" as entities;
import "package:app/infra/.index.dart" as infra;

final class ExchangeRepository {
  Future<entities.ExchangeData> getExchangeData({
    required String currency,
    required String date,
  }) async {
    final response = await infra.Http.request(
      infra.HttpMethod.get,
      "/exchange/$currency?date=$date",
    );

    if (response.isSuccess) {
      return entities.ExchangeData.fromJson(response.data);
    } else {
      throw Exception(response.errorMessage);
    }
  }
}
