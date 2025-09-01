import 'package:hive/hive.dart';
part 'property_type.g.dart';

@HiveType(typeId: 5)
enum PropertyType {
  @HiveField(0)
  apartment,
  @HiveField(1)
  shop,
  @HiveField(2)
  office,
  @HiveField(3)
  farm,
  @HiveField(4)
  roof,
  @HiveField(5)
  annex,
  @HiveField(6)
  villa;

  static PropertyType getFromString(String string) {
    return switch (string) {
      "شقة" => PropertyType.apartment,
      "سطح" => PropertyType.roof,
      "ملحق" => PropertyType.annex,
      "محل" => PropertyType.shop,
      "مكتب" => PropertyType.office,
      "مزرعة" => PropertyType.farm,
      "فيلا" => PropertyType.villa,
      _ => throw ArgumentError('Unknown property type string: $string'),
    };
  }

  String get arName {
    return switch (this) {
      PropertyType.apartment => "شقة",
      PropertyType.shop => "محل",
      PropertyType.annex => "ملحق",
      PropertyType.roof => "سطح",
      PropertyType.office => "مكتب",
      PropertyType.farm => "مزرعة",
      PropertyType.villa => "فيلا",
    };
  }
}
