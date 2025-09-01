import 'package:hive/hive.dart';

part 'types_local.g.dart'; // مهم لتوليد الكود

@HiveType(typeId: 1) // typeId يجب أن يكون رقم فريد
enum Types {
  @HiveField(0)
  sell,

  @HiveField(1)
  rentOut,

  @HiveField(2)
  buy,

  @HiveField(3)
  rent;

  bool get isBuyOrSell => this == sell || this == buy;
  bool get isOffer => this == sell || this == rentOut;
  bool get isRequest => this == rent || this == buy;

  String get arName {
    return switch (this) {
      sell => "للبيع",
      buy => "للشراء",
      rent => "للاستئجاء",
      rentOut => "للإيجار",
    };
  }

  static Types getFromString(String string) {
    return switch (string) {
      "عرض بيع" => sell,
      "طلب شراء" => buy,
      "طلب استئجار" => rent,
      "عرض إيجار" => rentOut,
      String() => throw UnimplementedError(),
    };
  }

  String get arNameTitle {
    return switch (this) {
      sell => "عرض بيع",
      buy => "طلب شراء",
      rent => "طلب استئجار",
      rentOut => "عرض إيجار",
    };
  }
}
