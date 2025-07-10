import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tripy_tropy/data/models/chat_message.dart';

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier({required String prompt, required String response})
      : super([
          ChatMessage(sender: 'user', message: prompt),
          ChatMessage(sender: 'ai', message: response),
        ]);

  Future<void> sendMessage(String userPrompt) async {
    // Add user's message
    state = [
      ...state,
      ChatMessage(sender: 'user', message: userPrompt),
      ChatMessage(sender: 'ai', message: '_TripyAI is thinking..._'),
    ];

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      updateLastAiMessage("❌ Gemini API Key is missing.");
      return;
    }

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey');

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": '''
You are a smart travel assistant.

Based on the user prompt:
"$userPrompt"

Create a concise day-by-day itinerary. BUT:

❗ Only suggest activities that are possible and realistic in that location.
❗ Do NOT include things like beach or scuba diving if it's a landlocked place like Lucknow.

Format strictly:
- Use "Day X:" headings.
- 2–4 short bullet points per day.
- Highlight places in **bold**.
- Add ([📍Google Maps](https://maps.google.com/?q=Mount+Fuji)) where relevant.
- No intro, no outro.
'''
            }
          ]
        }
      ]
    });

    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);

      final data = jsonDecode(response.body);
      final candidates = data['candidates'];
      final parts = candidates?[0]?['content']?['parts'];

      final reply = parts != null && parts.isNotEmpty
          ? parts[0]['text']?.toString().trim()
          : "⚠️ No response from Gemini.";

      updateLastAiMessage(reply ?? "⚠️ Gemini sent empty response.");
    } catch (e) {
      updateLastAiMessage("❌ Error: ${e.toString()}");
    }
  }

  void updateLastAiMessage(String newText) {
    final updated = [...state];
    updated.removeLast(); // Remove 'thinking...' message
    updated.add(ChatMessage(sender: 'ai', message: newText));
    state = updated;
  }
}

final chatProvider = StateNotifierProvider.autoDispose
    .family<ChatNotifier, List<ChatMessage>, Map<String, String>>((ref, args) {
  ref.keepAlive(); // Optional: to keep the chat alive during screen transitions
  return ChatNotifier(
    prompt: args['prompt']!,
    response: args['response']!,
  );
});
