import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  const baseUrl = "http://192.168.0.9:8080/api/rooms/all";

  final response = await http.get(Uri.parse(baseUrl));

  print("Status: ${response.statusCode}");
  print("Body: ${utf8.decode(response.bodyBytes)}");
}
