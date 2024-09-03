import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiUtil {
  static const String baseUrl = 'http://192.168.1.15:8000';

  static Future<http.Response> postRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {'Content-Type': 'application/json'};
    return await http.post(url, headers: headers, body: jsonEncode(body));
  }

  static Future<http.Response> getRequest(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = {'Content-Type': 'application/json'};
    return await http.get(url, headers: headers);
  }
}