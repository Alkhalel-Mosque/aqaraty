// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConditionAdapter extends TypeAdapter<Condition> {
  @override
  final int typeId = 20;

  @override
  Condition read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Condition.superDeluxe;
      case 1:
        return Condition.neW;
      case 2:
        return Condition.good;
      case 3:
        return Condition.old;
      case 4:
        return Condition.structureOnly;
      default:
        return Condition.superDeluxe;
    }
  }

  @override
  void write(BinaryWriter writer, Condition obj) {
    switch (obj) {
      case Condition.superDeluxe:
        writer.writeByte(0);
        break;
      case Condition.neW:
        writer.writeByte(1);
        break;
      case Condition.good:
        writer.writeByte(2);
        break;
      case Condition.old:
        writer.writeByte(3);
        break;
      case Condition.structureOnly:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConditionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
