import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/models/custom_plant_model.dart';
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FetchCustomPlantsApi {
  final http.Client client;

  FetchCustomPlantsApi({http.Client? client})
    : client = client ?? http.Client();

  Future<List<CustomPlantModel>> fetchPlants() async {
    final userId = CookieSingleton().jwtPayload?.id;
    final uri = Uri.parse(
      '${dotenv.env['API_BASE_URL']}/customplants/user/$userId',
    );
    final jwt = CookieSingleton().jwtCookie;

    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwt!},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(
        'Response body: ${response.body} \n Response status: ${response.statusCode}',
      );
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => CustomPlantModel.fromJson(data)).toList();
    } else {
      throw Exception('Fejl ved hentning af customplants');
    }
  }
}
