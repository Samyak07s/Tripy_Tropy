import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:tripy_tropy/data/models/itinerary_model.dart';

final savedItineraryProvider = StateNotifierProvider<SavedItineraryNotifier, List<ItineraryModel>>((ref) {
  return SavedItineraryNotifier()..loadSaved();
});

class SavedItineraryNotifier extends StateNotifier<List<ItineraryModel>> {
  SavedItineraryNotifier() : super([]);

  Future<void> loadSaved() async {
    final box = Hive.box<ItineraryModel>('saved_itineraries');
    state = box.values.toList();
  }

  Future<void> saveItinerary(ItineraryModel model) async {
    final box = Hive.box<ItineraryModel>('saved_itineraries');
    await box.add(model);
    state = box.values.toList(); 
    loadSaved();
  }

  Future<void> removeItinerary(ItineraryModel model) async {
    final box = Hive.box<ItineraryModel>('saved_itineraries');
    final key = box.keys.firstWhere((k) => box.get(k) == model, orElse: () => null);
    if (key != null) {
      await box.delete(key);
      loadSaved();
    }
  }
}
