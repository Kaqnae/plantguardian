import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/models/generic_plant_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FetchGenericPlantsApi {
  final http.Client client;

  FetchGenericPlantsApi({http.Client? client})
    : client = client ?? http.Client();

  Future<List<GenericPlantModel>> fetchPlants() async {
    final uri = Uri.parse('${dotenv.env['API_BASE_URL']}/genericplants');
    //final uri = Uri.parse('http://192.168.0.24:3000/api/genericplants');

    final jwtToken = CookieSingleton().jwtCookie;

    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwtToken!},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => GenericPlantModel.fromJson(data)).toList();
    } else {
      throw Exception('Fejl ved henting af data');
    }
  }
}
