import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  Future<http.Response> signUp({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_BASE_URL']}/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'role': 20,
        'userName': username,
        'email': email,
        'password': password,
      }),
    );
    return response;
  }
}
