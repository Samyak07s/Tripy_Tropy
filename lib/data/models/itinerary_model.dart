import 'package:hive/hive.dart';

part 'itinerary_model.g.dart'; 

@HiveType(typeId: 0)
class ItineraryModel extends HiveObject {
  @HiveField(0)
  final String prompt;

  @HiveField(1)
  final String response;

  ItineraryModel({required this.prompt, required this.response});
}
