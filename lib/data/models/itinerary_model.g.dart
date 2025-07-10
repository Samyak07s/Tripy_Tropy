// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItineraryModelAdapter extends TypeAdapter<ItineraryModel> {
  @override
  final int typeId = 0;

  @override
  ItineraryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItineraryModel(
      prompt: fields[0] as String,
      response: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ItineraryModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.prompt)
      ..writeByte(1)
      ..write(obj.response);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItineraryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
