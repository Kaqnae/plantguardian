import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UpdateCustomPlantsApi {
  final http.Client client;

  UpdateCustomPlantsApi({http.Client? client})
    : client = client ?? http.Client();

  Future<void> updateCustomPlant(CustomPlantModel plant) async {
    final uri = Uri.parse(
      '${dotenv.env['API_BASE_URL']}/customplants/${plant.id}',
    );
    final jwt = CookieSingleton().jwtCookie;

    final response = await client.put(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwt!},
      body: jsonEncode(plant.toJson()),
    );

    print('Update response code: ${response.statusCode}');

    if (response.statusCode != 201) {
      throw Exception('Failed to update plant: ${response.body}');
    }
  }
}
