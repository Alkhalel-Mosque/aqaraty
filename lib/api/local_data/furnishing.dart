import 'package:hive/hive.dart';
part 'furnishing.g.dart';

@HiveType(typeId: 11)
enum Furnishing {
  @HiveField(0)
  full,
  @HiveField(1)
  semi,
  @HiveField(2)
  none;

  String get arName {
    return switch (this) {
      full => "مفروش",
      semi => "نصف مفروش",
      none => "غير مفروش",
    };
  }

  static Furnishing getFromString(String string) {
    return switch (string) {
      "مفروش" => full,
      "نصف مفروش" => semi,
      "غير مفروش" => none,
      String() => throw UnimplementedError(),
    };
  }
}
