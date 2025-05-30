import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:plantguardian/features/shared/models/jwt_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginApiService {
  final http.Client client;

  LoginApiService({http.Client? client}) : client = client ?? http.Client();

  Future<bool> login(String username, String password) async {
    final uri = Uri.parse('${dotenv.env['API_BASE_URL']}/login');

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        final cookie = setCookie.split(';').first;
        CookieSingleton().jwtCookie = cookie;

        final token = cookie.split('=').last.replaceAll('"', '');
        final tokenParts = token.split('.');
        if (tokenParts.length == 3) {
          final payload = tokenParts[1];
          final normalized = base64Url.normalize(payload);
          final decoded = utf8.decode(base64Url.decode(normalized));
          final payloadMap = jsonDecode(decoded);

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
      debugPrint('Login failed: ${response.statusCode}');
      return false;
    }
  }
}
