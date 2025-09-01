// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'furnishing.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FurnishingAdapter extends TypeAdapter<Furnishing> {
  @override
  final int typeId = 11;

  @override
  Furnishing read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Furnishing.full;
      case 1:
        return Furnishing.semi;
      case 2:
        return Furnishing.none;
      default:
        return Furnishing.full;
    }
  }

  @override
  void write(BinaryWriter writer, Furnishing obj) {
    switch (obj) {
      case Furnishing.full:
        writer.writeByte(0);
        break;
      case Furnishing.semi:
        writer.writeByte(1);
        break;
      case Furnishing.none:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FurnishingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
