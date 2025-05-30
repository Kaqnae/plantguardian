import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DeleteCustomPlantsApi {
  final http.Client client;

  DeleteCustomPlantsApi({http.Client? client})
    : client = client ?? http.Client();

  Future<void> deleteCustomPlant(String id) async {
    final uri = Uri.parse('${dotenv.env['API_BASE_URL']}/customplants/$id');

    final jwtToken = CookieSingleton().jwtCookie;

    final response = await client.delete(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwtToken!},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Could not delete plant');
    }
  }
}
