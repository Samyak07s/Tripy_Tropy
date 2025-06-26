import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripy_tropy/services/ai_service.dart';

final aiProvider = FutureProvider.family<String, String>((ref, prompt) async {
  return await AIService.generateItinerary(prompt);
});
