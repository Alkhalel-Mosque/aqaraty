import 'package:hive/hive.dart';
part 'condition.g.dart';

@HiveType(typeId: 4)
enum Condition {
  @HiveField(0)
  superDeluxe,
  @HiveField(1)
  neW,
  @HiveField(2)
  good,
  @HiveField(3)
  old,
  @HiveField(4)
  structureOnly;

  static Condition getFromString(String string) {
    return switch (string) {
      "سوبر ديلوكس" => Condition.superDeluxe,
      "جديدة" => Condition.neW,
      "جيدة" => Condition.good,
      "قديمة" => Condition.old,
      "على العظم" => Condition.structureOnly,
      _ => throw ArgumentError('Unknown condition string: $string'),
    };
  }

  String get arName {
    return switch (this) {
      Condition.superDeluxe => "سوبر ديلوكس",
      Condition.neW => "جديدة",
      Condition.good => "جيدة",
      Condition.old => "قديمة",
      Condition.structureOnly => "على العظم",
    };
  }
}
