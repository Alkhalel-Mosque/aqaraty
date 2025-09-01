// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'direction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DirectionAdapter extends TypeAdapter<Direction> {
  @override
  final int typeId = 3;

  @override
  Direction read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Direction.east;
      case 1:
        return Direction.west;
      case 2:
        return Direction.north;
      case 3:
        return Direction.south;
      default:
        return Direction.east;
    }
  }

  @override
  void write(BinaryWriter writer, Direction obj) {
    switch (obj) {
      case Direction.east:
        writer.writeByte(0);
        break;
      case Direction.west:
        writer.writeByte(1);
        break;
      case Direction.north:
        writer.writeByte(2);
        break;
      case Direction.south:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DirectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
