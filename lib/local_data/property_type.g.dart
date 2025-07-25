// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertyTypeAdapter extends TypeAdapter<PropertyType> {
  @override
  final int typeId = 5;

  @override
  PropertyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PropertyType.apartment;
      case 1:
        return PropertyType.shop;
      case 2:
        return PropertyType.office;
      case 3:
        return PropertyType.farm;
      case 4:
        return PropertyType.roof;
      case 5:
        return PropertyType.annex;
      case 6:
        return PropertyType.villa;
      default:
        return PropertyType.apartment;
    }
  }

  @override
  void write(BinaryWriter writer, PropertyType obj) {
    switch (obj) {
      case PropertyType.apartment:
        writer.writeByte(0);
        break;
      case PropertyType.shop:
        writer.writeByte(1);
        break;
      case PropertyType.office:
        writer.writeByte(2);
        break;
      case PropertyType.farm:
        writer.writeByte(3);
        break;
      case PropertyType.roof:
        writer.writeByte(4);
        break;
      case PropertyType.annex:
        writer.writeByte(5);
        break;
      case PropertyType.villa:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
