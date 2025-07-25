// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'features.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeaturesAdapter extends TypeAdapter<Features> {
  @override
  final int typeId = 7;

  @override
  Features read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Features.solarPower;
      case 1:
        return Features.balcony;
      case 2:
        return Features.solarWater;
      case 3:
        return Features.elevator;
      case 4:
        return Features.parking;
      case 5:
        return Features.pool;
      default:
        return Features.solarPower;
    }
  }

  @override
  void write(BinaryWriter writer, Features obj) {
    switch (obj) {
      case Features.solarPower:
        writer.writeByte(0);
        break;
      case Features.balcony:
        writer.writeByte(1);
        break;
      case Features.solarWater:
        writer.writeByte(2);
        break;
      case Features.elevator:
        writer.writeByte(3);
        break;
      case Features.parking:
        writer.writeByte(4);
        break;
      case Features.pool:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeaturesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
