import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service class for deleting a custom plant from the backend API.
class DeleteCustomPlantsApi {
  final http.Client client;

  /// Constructor accepts optional [client], defaults to a new [http.Client].
  DeleteCustomPlantsApi({http.Client? client})
    : client = client ?? http.Client();

  /// Sends a DELETE request to remove a custom plant by its ID.
  /// Uses the JWT cookie for authentication.
  /// Throws an exception if the request fails.
  Future<void> deleteCustomPlant(String id) async {
    // Build the URI for the custom plant to delete.
    final uri = Uri.parse('${dotenv.env['API_BASE_URL']}/customplants/$id');

    // Retrieve the JWT cookie for authentication.
    final jwtToken = CookieSingleton().jwtCookie;

    // Make the DELETE request to the backend.
    final response = await client.delete(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwtToken!},
    );

    // If the request fails, throw an exception.
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Could not delete plant');
    }
  }
}
