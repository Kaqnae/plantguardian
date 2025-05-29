import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/models/profile_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service for fetching the user profile from the API.
class FetchUserApi {
  /// HTTP client used to make requests.
  final http.Client client;

  /// Constructor accepts optional [client], defaults to a new [http.Client].
  FetchUserApi({http.Client? client})
    : client = client ?? http.Client();

  /// Fetches the user profile using the stored JWT for authentication.
  /// 
  /// Returns a [Profile] if successful.
  /// Throws an [Exception] if the request fails.
  Future<Profile> fetchUser() async {
    // Construct the API endpoint using the base URL and user ID from JWT.
    final uri = Uri.parse('${dotenv.env['API_BASE_URL']}/users/${CookieSingleton().jwtPayload!.id}');
    // Get the JWT cookie for authorization.
    final jwt = CookieSingleton().jwtCookie;

    // Send a GET request with the JWT in the headers.
    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwt!},
    );

    // Parse and return the Profile if successful.
    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      return Profile.fromJson(jsonData);
    } else {
      // Throw error if the request failed.
      throw Exception('Error fetching user.');
    }
  }
}