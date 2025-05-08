import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';

class LoginApiService {
  final http.Client client;

  LoginApiService({http.Client? client}) : client = client ?? http.Client();

  Future<bool> login(String username, String password) async {
    final uri = Uri.parse('http://10.0.2.2:3000/api/login');

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
