import 'dart:convert';
import 'package:http/http.dart' as http;

class SendMailManager {
  Future<bool> sendEmail(String message, String? userid, String? username, String platform) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_y36gyfq';
    const templateId = 'template_gg9tlpa';
    const userId = 'user_WCMKuUGtdhnF1DoPeoN3B';
    const accessToken = 'fe57cace2748197cd08d3abdcf3a3403';

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'}, //This line makes sure it works for all platforms.
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'accessToken': accessToken,
        'template_params': {
          'message': message,
          'userid': userid ?? 'unknown',
          'username': username ?? 'unknown',
          'platform': platform,
        }
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }
}
