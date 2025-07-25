// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TypesAdapter extends TypeAdapter<Types> {
  @override
  final int typeId = 1;

  @override
  Types read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Types.sell;
      case 1:
        return Types.rentOut;
      case 2:
        return Types.buy;
      case 3:
        return Types.rent;
      default:
        return Types.sell;
    }
  }

  @override
  void write(BinaryWriter writer, Types obj) {
    switch (obj) {
      case Types.sell:
        writer.writeByte(0);
        break;
      case Types.rentOut:
        writer.writeByte(1);
        break;
      case Types.buy:
        writer.writeByte(2);
        break;
      case Types.rent:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
