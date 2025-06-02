import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service class for updating an existing custom plant in the backend API.
class UpdateCustomPlantsApi {
  final http.Client client;

  /// Constructor accepts optional [client], defaults to a new [http.Client].
  UpdateCustomPlantsApi({http.Client? client})
    : client = client ?? http.Client();

  /// Sends a PUT request to update a custom plant by its ID.
  /// Uses the JWT cookie for authentication.
  /// Throws an exception if the request fails.
  Future<void> updateCustomPlant(CustomPlantModel plant) async {
    // Build the URI for the custom plant to update.
    final uri = Uri.parse(
      '${dotenv.env['API_BASE_URL']}/customplants/${plant.id}',
    );
    // Retrieve the JWT cookie for authentication.
    final jwt = CookieSingleton().jwtCookie;

    // Make the PUT request to the backend with the updated plant data.
    final response = await client.put(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwt!},
      body: jsonEncode(plant.toJson()),
    );

    // If the request fails, throw an exception with the response body.
    if (response.statusCode != 201) {
      throw Exception('Failed to update plant: ${response.body}');
    }
  }
}
