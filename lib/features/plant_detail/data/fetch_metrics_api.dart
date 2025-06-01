import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/models/metrics_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service class for fetching metrics data for a specific custom plant.
class FetchMetricsApi {
  final http.Client client;

  /// Constructor allows injecting a custom HTTP client (useful for testing).
  FetchMetricsApi({http.Client? client}) : client = client ?? http.Client();

  /// Fetches all metrics for a given custom plant ID.
  /// Uses the JWT cookie for authentication.
  /// Throws an exception if the request fails.
  Future<List<MetricsModel>> fetchMetrics(String customPlantId) async {
    // Build the URI for fetching metrics for the given custom plant.
    final uri = Uri.parse(
      '${dotenv.env['API_BASE_URL']}/metrics/$customPlantId',
    );

    // Retrieve the JWT cookie for authentication.
    final jwt = CookieSingleton().jwtCookie;

    // Make the GET request to the backend.
    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwt!},
    );

    // If successful, parse the response and return a list of MetricsModel.
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => MetricsModel.fromJson(data)).toList();
    } else {
      // If not successful, throw an exception.
      throw Exception('Failed to fetch metrics');
    }
  }
}
