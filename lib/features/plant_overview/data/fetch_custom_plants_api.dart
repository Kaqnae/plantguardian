import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service class to fetch custom plants from the API
class FetchCustomPlantsApi {
  final http.Client client;

  /// Constructor accepts optional [client], defaults to a new [http.Client].
  FetchCustomPlantsApi({http.Client? client})
    : client = client ?? http.Client();

  /// Fetches all custom plants for the currently logged in user
  /// Uses the user ID from the JWT payload to construct the API endpoint
  /// Throws an exception if the request fails
  Future<List<CustomPlantModel>> fetchPlants() async {
    // Get the user ID from the JWT payload stored in CookieSingleton
    final userId = CookieSingleton().jwtPayload?.id;
    // URI for fetching custom plants, using the user ID
    final uri = Uri.parse(
      '${dotenv.env['API_BASE_URL']}/customplants/user/$userId',
    );
    // Retrieve the JWT cookie for authentication
    final jwt = CookieSingleton().jwtCookie;

    // Make the GET request to the API
    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwt!},
    );

    // If successful, parse the response and return a list of CustomPlants
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => CustomPlantModel.fromJson(data)).toList();
    } else {
      // If not successful, throw an exception
      throw Exception('Fejl ved hentning af customplants');
    }
  }
}
