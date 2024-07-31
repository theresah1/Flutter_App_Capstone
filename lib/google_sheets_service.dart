import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class GoogleSheetsService {
  static const String url = "https://script.google.com/macros/s/AKfycbxLxuLNkKUsSkwzS_7tocKN1Av6wfwK03Yshe0EU_i3BFoZfaHPLZtcJRwPlWNChFUJQw/exec";
  Future<Map<String, dynamic>> fetchReadings() async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse is List && jsonResponse.isNotEmpty && jsonResponse[0] is Map) {
          return jsonResponse[0] as Map<String, dynamic>;
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to fetch readings, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetchinTMg readings: $e');
      throw e;
    }
  }
}
