import 'package:hive/hive.dart';

part 'currency2.g.dart';

@HiveType(typeId: 20)
enum Currency {
  @HiveField(0)
  SYP,
  @HiveField(1)
  USD;

  String formatPrice(int? price) {
    if (price == null) return "0 $symbol";
    final RegExp priceRegExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String priceFormat(Match match) => '${match[1]},';

    String formattedPrice =
        price.toString().replaceAllMapped(priceRegExp, priceFormat);

    return "$formattedPrice $symbol";
  }

  String get symbol {
    switch (this) {
      case Currency.USD:
        return "\$";

      case Currency.SYP:
        return "ل.س";
    }
  }
}
