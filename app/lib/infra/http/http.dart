import "dart:convert";

import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;

final class Response<T> {
  Response({
    required this.isSuccess,
    required this.errorMessage,
    required this.data,
  });

  final bool isSuccess;
  final String? errorMessage;
  final T data;

  factory Response.fromJson(Map<String, dynamic> json) {
    final isSuccess = json["is_success"] as bool;
    final errorMessage = json["error_message"] as String?;
    final data = json["data"] as dynamic;

    late T dataCasted;

    if (data is List) {
      dataCasted = data.map((item) => item as Map<String, dynamic>).toList() as T;
    } else if (data is Map) {
      dataCasted = data as T;
    } else {
      throw Exception("data is not supported");
    }

    return Response(
      isSuccess: isSuccess,
      errorMessage: errorMessage,
      data: dataCasted,
    );
  }
}

enum HttpMethod {
  get,
}

final class Http {
  static String? baseUrl = dotenv.env["BASE_URL"];

  static Future<Response<T>> request<T>(
    HttpMethod method,
    String path,
  ) async {
    if (baseUrl == null) {
      throw Exception("BASE_URL is not set");
    }

    final Uri uri = Uri.parse("$baseUrl/api$path");
    late http.Response response;

    await Future<void>.delayed(const Duration(seconds: 3));

    switch (method) {
      case HttpMethod.get:
        response = await http.get(uri);
        break;
    }

    return Response.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }
}
