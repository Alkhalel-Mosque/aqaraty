import 'package:hive/hive.dart';
part 'features.g.dart';

@HiveType(typeId: 7)
enum Features {
  @HiveField(0)
  solarPower,
  @HiveField(1)
  balcony,
  @HiveField(2)
  solarWater,
  @HiveField(3)
  elevator,
  @HiveField(4)
  parking,
  @HiveField(5)
  pool;

  String get arName {
    return switch (this) {
      solarPower => "طاقة شمسية",
      balcony => "برندة",
      solarWater => "سخان شمسي",
      elevator => "مصعد",
      parking => "مرآب",
      pool => "مسبح",
    };
  }
}
