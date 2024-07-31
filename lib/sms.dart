import 'package:http/http.dart' as http;
import 'dart:convert';




Future<void> sendSms(String apiKey, String apiSecret, String toPhoneNumber, String fromPhoneNumber, String message) async {
  final url = Uri.parse('https://rest.nexmo.com/sms/json');
  final response = await http.post(
    url,
    body: {
      'api_key': apiKey,
      'api_secret': apiSecret,
      'to': toPhoneNumber,
      'from': fromPhoneNumber,
      'text': message,
    },
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    print('SMS Response: $responseBody');

    if (responseBody['messages'][0]['status'] == '0') {
      print('SMS sent successfully');
    } else {
      print('Failed to send SMS: ${responseBody['messages'][0]['error-text']}');
    }
  } else {
    print('HTTP error: ${response.statusCode}');
    print('HTTP response: ${response.body}');
  }
}

void main() {
  const String nexmoApiKey = 'b0afc461';
  const String nexmoApiSecret = 'q3dyQVyPL0QrO2wH';
  const String fromPhoneNumber = 'Vonage APIs';
  const String toPhoneNumber = '233552536846';
  const String message = 'This is a test message from your Flutter app';

  sendSms(nexmoApiKey, nexmoApiSecret, toPhoneNumber, fromPhoneNumber, message);
}
