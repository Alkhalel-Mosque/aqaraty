import 'package:hive/hive.dart';
part 'direction.g.dart';

@HiveType(typeId: 3)
enum Direction {
  @HiveField(0)
  east,
  @HiveField(1)
  west,
  @HiveField(2)
  north,
  @HiveField(3)
  south;

  String get arName {
    return switch (this) {
      east => "شرقي",
      west => "غربي",
      north => "شمالي",
      south => "جنوبي",
    };
  }

  static Direction getFromString(String string) {
    return switch (string) {
      "شرقي" => east,
      "غربي" => west,
      "شمالي" => north,
      "جنوبي" => south,
      String() => throw UnimplementedError(),
    };
  }
}
