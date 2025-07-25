// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ownershipType.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OwnershipTypeAdapter extends TypeAdapter<OwnershipType> {
  @override
  final int typeId = 6;

  @override
  OwnershipType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OwnershipType.housingTitle;
      case 1:
        return OwnershipType.sharesTitle;
      case 2:
        return OwnershipType.greenTitle;
      case 3:
        return OwnershipType.courtJudgement;
      case 4:
        return OwnershipType.outrightSellContract;
      case 5:
        return OwnershipType.agriculturalTitle;
      case 6:
        return OwnershipType.rightOfUse;
      case 7:
        return OwnershipType.govermentProperty;
      case 8:
        return OwnershipType.temporaryRegister;
      default:
        return OwnershipType.housingTitle;
    }
  }

  @override
  void write(BinaryWriter writer, OwnershipType obj) {
    switch (obj) {
      case OwnershipType.housingTitle:
        writer.writeByte(0);
        break;
      case OwnershipType.sharesTitle:
        writer.writeByte(1);
        break;
      case OwnershipType.greenTitle:
        writer.writeByte(2);
        break;
      case OwnershipType.courtJudgement:
        writer.writeByte(3);
        break;
      case OwnershipType.outrightSellContract:
        writer.writeByte(4);
        break;
      case OwnershipType.agriculturalTitle:
        writer.writeByte(5);
        break;
      case OwnershipType.rightOfUse:
        writer.writeByte(6);
        break;
      case OwnershipType.govermentProperty:
        writer.writeByte(7);
        break;
      case OwnershipType.temporaryRegister:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnershipTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
