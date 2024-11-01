import "dart:convert";

import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;

final class Response {
  Response({
    required this.isSuccess,
    required this.errorMessage,
    required this.data,
  });

  final bool isSuccess;
  final String? errorMessage;
  final Map<String, dynamic> data;

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      isSuccess: json["is_success"] as bool,
      errorMessage: json["error_message"] as String?,
      data: json["data"] == null ? {} : json["data"] as Map<String, dynamic>,
    );
  }
}

enum HttpMethod {
  get,
}

final class Http {
  static String? baseUrl = dotenv.env["BASE_URL"];

  static Future<Response> request(
    HttpMethod method,
    String path,
  ) async {
    if (baseUrl == null) {
      throw Exception("BASE_URL is not set");
    }

    final Uri uri = Uri.parse("$baseUrl/api$path");
    late http.Response response;

    switch (method) {
      case HttpMethod.get:
        response = await http.get(uri);
        break;
    }

    return Response.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }
}
