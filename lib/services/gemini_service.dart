import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const _apiKey = 'AIzaSyDyamL809O9GjZzd6c-gRh03cqVdxHiS6w';
  static const _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$_apiKey';

  static Future<String> generateItinerary(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];
        return text ?? "No itinerary generated.";
      } else {
        return "Error ${response.statusCode}: ${response.reasonPhrase}";
      }
    } catch (e) {
      return "Something went wrong: $e";
    }
  }
}
