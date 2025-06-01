import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service class for posting (creating) a new custom plant to the backend API.
class PostCustomPlantApi {
  final http.Client client;

  /// Constructor allows injecting a custom HTTP client (useful for testing).
  PostCustomPlantApi({http.Client? client}) : client = client ?? http.Client();

  /// Sends a POST request to create a new custom plant.
  /// Uses the JWT cookie for authentication.
  /// Throws an exception if the request fails.
  Future<void> createCustomPlant(CustomPlantModel plant) async {
    // Build the URI for the custom plants endpoint.
    final uri = Uri.parse('${dotenv.env['API_BASE_URL']}/customplants');

    // Retrieve the JWT cookie for authentication.
    final jwt = CookieSingleton().jwtCookie;

    // Make the POST request to the backend with the plant data.
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwt!},
      body: jsonEncode(plant.toJson()),
    );

    // If the request fails, throw an exception.
    if (response.statusCode != 201) {
      throw Exception('Couldnt post customplant');
    }
  }
}
