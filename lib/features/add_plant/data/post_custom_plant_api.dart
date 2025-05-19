import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';

class PostCustomPlantApi {
  final http.Client client;

  PostCustomPlantApi({http.Client? client}) : client = client ?? http.Client();

  Future<void> createCustomPlant(CustomPlantModel plant) async {
    final uri = Uri.parse('http://10.176.69.182:3000/api/customplants');
    final jwt = CookieSingleton().jwtCookie;

    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwt!},
      body: jsonEncode(plant.toJson()),
    );

    if (response.statusCode == 201) {
      print('Posted customplant: ${plant.toJson()}');
    } else {
      throw Exception('Couldnt post customplant');
    }
  }
}
