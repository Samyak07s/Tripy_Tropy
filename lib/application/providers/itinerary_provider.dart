import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final itineraryProvider =
    FutureProvider.family<String, String>((ref, prompt) async {
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    throw Exception("Missing Gemini API Key");
  }

  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
  );

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": """
Generate a day-by-day travel itinerary based on this prompt: "$prompt".

STRICT FORMAT ONLY:
- Use the format "Day X:" as a heading for each day.
- Under each day, list 2–4 bullet points with brief activity descriptions.
- Each bullet must be a single short line.
- Add Google Maps or official links to places where possible.
- Bold key places or activities using markdown **like this**.
- Do NOT write long paragraphs or explanations.
- Do NOT include introductions or conclusions.

Example output:

Day 1:
- Arrive in **Tokyo** ([📍Google Maps](https://maps.google.com/?q=Tokyo))
- Visit **Shibuya Crossing** ([link](https://maps.google.com/?q=Shibuya+Crossing))
- Eat **sushi** at **Tsukiji Market** ([link](https://www.tsukiji.or.jp/english/))

Day 2:
- Day trip to **Mount Fuji** ([📍Google Maps](https://maps.google.com/?q=Mount+Fuji))
- Return and explore **Kyoto Gion District** ([link](https://maps.google.com/?q=Gion+Kyoto))
"""
            }
          ]
        }
      ]
    }),
  );

  final data = jsonDecode(response.body);
  final candidates = data['candidates'];
  print('Response body: ${response.body}');

  if (candidates == null || candidates.isEmpty) {
    throw Exception("No candidates returned from Gemini API");
  }

  final content = candidates[0]['content'];
  final parts = content['parts'];

  if (parts == null || parts.isEmpty || parts[0]['text'] == null) {
    throw Exception("Invalid response format from Gemini API");
  }

  return parts[0]['text'].toString().trim();
});
