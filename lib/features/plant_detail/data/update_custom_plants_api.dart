import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';

class UpdateCustomPlantsApi {
  final http.Client client;

  UpdateCustomPlantsApi({http.Client? client})
    : client = client ?? http.Client();

  Future<void> updateCustomPlant(CustomPlantModel plant) async {
    final uri = Uri.parse(
      'http://10.176.69.182:3000/api/customplants/${plant.id}',
    );
    final jwt = CookieSingleton().jwtCookie;

    final response = await client.put(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwt!},
      body: jsonEncode(plant.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update plant: ${response.body}');
    }
  }
}
