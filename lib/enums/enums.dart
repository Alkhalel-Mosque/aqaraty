enum Types {
  sell,
  buy,
  rent,
  rentOut;

  String get arName {
    return switch (this) {
      sell => "للبيع",
      buy => "للشراء",
      rent => "للاستئجاء",
      rentOut => "للإيجار",
    };
  }
}

enum Furnishing { full, semi, none }

enum Direction { east, west, north, south }

enum Condition { superDeluxe, neW, good, old, structureOnly }

enum PropertyType {
  apartment,
  shop,
  office,
  farm,
  villa;

  String get arName {
    return switch (this) {
      apartment => "شقة",
      shop => "محل",
      office => "مكتب",
      farm => "مزرعة",
      villa => "فيلا",
    };
  }
}

enum OwnershipType {
  housingTitle,
  sharesTitle,
  greenTitle,
  courtJudgement,
  outrightSellContract,
  agriculturalTitle,
  rightOfUse,
  temporaryRegister
}

enum Features { solarPower, balcony, solarWater, elevator, parking, pool }
