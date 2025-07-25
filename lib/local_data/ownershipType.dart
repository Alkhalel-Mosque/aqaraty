import 'package:hive/hive.dart';
part 'ownershipType.g.dart';

@HiveType(typeId: 6)
enum OwnershipType {
  @HiveField(0)
  housingTitle,
  @HiveField(1)
  sharesTitle,
  @HiveField(2)
  greenTitle,
  @HiveField(3)
  courtJudgement,
  @HiveField(4)
  outrightSellContract,
  @HiveField(5)
  agriculturalTitle,
  @HiveField(6)
  rightOfUse,
  @HiveField(7)
  govermentProperty,
  @HiveField(8)
  temporaryRegister;

  static OwnershipType getFromString(String string) {
    return switch (string.trim()) {
      // Added trim() to handle whitespace
      "طابو إسكان" => OwnershipType.housingTitle,
      "طابو أسهم" => OwnershipType.sharesTitle,
      "طابو أخضر" => OwnershipType.greenTitle,
      "حكم محكمة" => OwnershipType.courtJudgement,
      "عقد بيع قطعي" => OwnershipType.outrightSellContract,
      "طابو زراعي" => OwnershipType.agriculturalTitle,
      "فروغ" => OwnershipType.rightOfUse,
      "أملاك دولة" => OwnershipType.govermentProperty,
      "سجل مؤقت" => OwnershipType.temporaryRegister,
      _ => throw ArgumentError('Unknown ownership type string: $string'),
    };
  }

  String get arName {
    return switch (this) {
      OwnershipType.housingTitle => "طابو إسكان",
      OwnershipType.sharesTitle => "طابو أسهم",
      OwnershipType.greenTitle => "طابو أخضر",
      OwnershipType.courtJudgement => "حكم محكمة",
      OwnershipType.outrightSellContract => "عقد بيع قطعي",
      OwnershipType.agriculturalTitle => "طابو زراعي",
      OwnershipType.rightOfUse => "فروغ",
      OwnershipType.govermentProperty => "أملاك دولة",
      OwnershipType.temporaryRegister => "سجل مؤقت",
    };
  }
}
