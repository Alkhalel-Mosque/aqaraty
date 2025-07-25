// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'real_estate.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RealEstateAdapter extends TypeAdapter<RealEstate> {
  @override
  final int typeId = 0;

  @override
  RealEstate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RealEstate(
      id: fields[0] as String?,
      type: fields[1] as Types?,
      propertyType: fields[2] as PropertyType?,
      locationArea: fields[3] as String?,
      locationMark: fields[4] as String?,
      condition: fields[14] as Condition?,
      price: fields[5] as int,
      floor: fields[6] as int?,
      coords: fields[26] as LatLng?,
      rooms: fields[7] as int,
      iswithRoof: fields[9] as bool,
      iswithSalon: fields[8] as bool,
      iswithSofa: fields[10] as bool,
      area: fields[11] as int?,
      direction: (fields[12] as List?)?.cast<Direction>(),
      ownershipType: fields[13] as OwnershipType?,
      customerName: fields[15] as String?,
      customerPhone: fields[16] as String?,
      officeName: fields[17] as String?,
      officePhone: fields[18] as String?,
      furnishing: fields[19] as Furnishing?,
      isOffice: fields[20] as bool,
      features: (fields[21] as List?)?.cast<Features>(),
      additionalInformation: fields[22] as String?,
      gallary: (fields[23] as List?)?.cast<String>(),
      createdById: fields[24] as String?,
      createdAt: fields[27] as DateTime?,
      requestStatus: fields[25] as RequestStatus?,
    );
  }

  @override
  void write(BinaryWriter writer, RealEstate obj) {
    writer
      ..writeByte(28)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.propertyType)
      ..writeByte(3)
      ..write(obj.locationArea)
      ..writeByte(4)
      ..write(obj.locationMark)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.floor)
      ..writeByte(7)
      ..write(obj.rooms)
      ..writeByte(8)
      ..write(obj.iswithSalon)
      ..writeByte(9)
      ..write(obj.iswithRoof)
      ..writeByte(10)
      ..write(obj.iswithSofa)
      ..writeByte(11)
      ..write(obj.area)
      ..writeByte(12)
      ..write(obj.direction)
      ..writeByte(13)
      ..write(obj.ownershipType)
      ..writeByte(14)
      ..write(obj.condition)
      ..writeByte(15)
      ..write(obj.customerName)
      ..writeByte(16)
      ..write(obj.customerPhone)
      ..writeByte(17)
      ..write(obj.officeName)
      ..writeByte(18)
      ..write(obj.officePhone)
      ..writeByte(19)
      ..write(obj.furnishing)
      ..writeByte(20)
      ..write(obj.isOffice)
      ..writeByte(21)
      ..write(obj.features)
      ..writeByte(22)
      ..write(obj.additionalInformation)
      ..writeByte(23)
      ..write(obj.gallary)
      ..writeByte(24)
      ..write(obj.createdById)
      ..writeByte(25)
      ..write(obj.requestStatus)
      ..writeByte(26)
      ..write(obj.coords)
      ..writeByte(27)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RealEstateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
