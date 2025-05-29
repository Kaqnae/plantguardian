import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantguardian/features/plant_detail/domain/metrics_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FetchMetricsApi {
  final http.Client client;

  FetchMetricsApi({http.Client? client}) : client = client ?? http.Client();

  Future<List<MetricsModel>> fetchMetrics(String customPlantId) async {
    final uri = Uri.parse(
      '${dotenv.env['API_BASE_URL']}/metrics/$customPlantId',
    );
    final jwt = CookieSingleton().jwtCookie;

    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwt!},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => MetricsModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch metrics');
    }
  }
}
