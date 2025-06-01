import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/models/generic_plant_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service class for fetching all generic plant types from the backend API.
class FetchGenericPlantsApi {
  final http.Client client;

  /// Constructor allows injecting a custom HTTP client (useful for testing).
  FetchGenericPlantsApi({http.Client? client})
    : client = client ?? http.Client();

  /// Fetches all generic plants from the backend.
  /// Uses the JWT cookie for authentication.
  /// Throws an exception if the request fails.
  Future<List<GenericPlantModel>> fetchPlants() async {
    // Build the URI for the generic plants endpoint.
    final uri = Uri.parse('${dotenv.env['API_BASE_URL']}/genericplants');

    // Retrieve the JWT cookie for authentication.
    final jwtToken = CookieSingleton().jwtCookie;

    // Make the GET request to the backend.
    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwtToken!},
    );

    // If successful, parse the response and return a list of GenericPlantModel.
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => GenericPlantModel.fromJson(data)).toList();
    } else {
      // If not successful, throw an exception.
      throw Exception('Fejl ved henting af data');
    }
  }
}
