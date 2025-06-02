import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:plantguardian/features/shared/models/jwt_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service class for handling user login and JWT cookie management.
class LoginApiService {
  final http.Client client;

  /// Constructor accepts optional [client], defaults to a new [http.Client].
  LoginApiService({http.Client? client}) : client = client ?? http.Client();

  /// Attempts to log in with the provided username and password.
  /// On success, stores the JWT cookie and payload in the CookieSingleton.
  /// Returns true if login is successful, false otherwise.
  Future<bool> login(String username, String password) async {
    // Build the URI for the login endpoint.
    final uri = Uri.parse('${dotenv.env['API_BASE_URL']}/login');

    // Send the POST request with username and password.
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    // If login is successful (status 200), process the JWT cookie.
    if (response.statusCode == 200) {
      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        // Extract the JWT cookie value.
        final cookie = setCookie.split(';').first;
        CookieSingleton().jwtCookie = cookie;

        // Parse the JWT token and extract the payload.
        final token = cookie.split('=').last.replaceAll('"', '');
        final tokenParts = token.split('.');
        if (tokenParts.length == 3) {
          final payload = tokenParts[1];
          final normalized = base64Url.normalize(payload);
          final decoded = utf8.decode(base64Url.decode(normalized));
          final payloadMap = jsonDecode(decoded);

          // Store the parsed JWT payload in the singleton.
          final parsedToken = JWTPayload.fromJson(payloadMap);
          CookieSingleton().jwtPayload = parsedToken;

          debugPrint(
            'JWT parsed and stored: ${parsedToken.name}, role: ${parsedToken.role}, id: ${parsedToken.id}',
          );
        } else {
          debugPrint('Invalid JWT structure.');
        }
        final singletonCookie = CookieSingleton().jwtCookie;
        debugPrint(
          'Login succesful. JWT set in cookie. JWTCookie: $singletonCookie',
        );
        return true;
      } else {
        debugPrint('Login successful, but no cookie set');
        return false;
      }
    } else {
      // If login fails, print the status code and return false.
      debugPrint('Login failed: ${response.statusCode}');
      return false;
    }
  }
}
