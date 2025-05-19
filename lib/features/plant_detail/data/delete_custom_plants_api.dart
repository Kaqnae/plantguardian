import 'package:http/http.dart' as http;
import 'package:plantguardian/features/shared/services/cookie_singleton.dart';

class DeleteCustomPlantsApi {
  final http.Client client;

  DeleteCustomPlantsApi({http.Client? client})
    : client = client ?? http.Client();

  Future<void> deleteCustomPlant(String id) async {
    final uri = Uri.parse('http://10.176.69.182:3000/api/customplants/$id');

    final jwtToken = CookieSingleton().jwtCookie;

    final response = await client.delete(
      uri,
      headers: {'Content-Type': 'application/json', 'Cookie': jwtToken!},
    );

    print('Response code: ${response.statusCode}');

    print('Response code: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Could not delete plant');
    }
  }
}
