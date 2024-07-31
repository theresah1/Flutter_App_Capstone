
import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleSheetsService {
  final String spreadsheetId;
  final String apiKey;

  GoogleSheetsService(this.spreadsheetId, this.apiKey);

  Future<List<Map>> fetchLastTenReadings() async {
    final url =
        'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/Sheet1!A1:C10?key=$apiKey';
    

    
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final rows = jsonResponse['values'] as List<dynamic>;
      final headers = rows.first as List<dynamic>;
      final dataRows = rows.skip(1);

      return dataRows.map((row) {
        return {
          // headers[0]: row[0],
          // headers[1]: row[1],
          // headers[2]: row[2],
          headers[0].toString(): row[0].toString(),
          headers[1].toString(): row[1].toString(),
          headers[2].toString(): row[2].toString(),
        };
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
