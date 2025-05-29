import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/models/profile_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service for updating the user profile via API.
class UpdateUserApi {
  /// HTTP client used for making requests.
  final http.Client client;

  /// Constructor accepts optional [client], defaults to new [http.Client].
  UpdateUserApi({http.Client? client})
    : client = client ?? http.Client();

  /// Sends a PUT request to update the user profile.
  /// 
  /// Returns `true` if update was successful (HTTP 201), otherwise `false`.
  Future<bool> updateUser(Profile profile) async {
    // Build the API URI using the base URL and the user ID from JWT.
    final uri = Uri.parse('${dotenv.env['API_BASE_URL']}/users/${CookieSingleton().jwtPayload!.id}');
    // Get the JWT cookie for authentication.
    final jwt = CookieSingleton().jwtCookie;

    // Make the PUT request with JSON body and appropriate headers.
    final response = await client.put(
      uri,
      headers: {
        'Content-Type': 'application/json', 
        'Cookie': jwt!
      },
      body: jsonEncode(profile.toJson()),
    );

    // Return true if the server responded with status 201 (Created).
    return response.statusCode == 201;
  }
}