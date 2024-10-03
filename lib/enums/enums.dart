enum Types {
  sell,
  rentOut,
  buy,
  rent;

// bool get isSellOrRentOut=>;
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

enum Furnishing {
  full,
  semi,
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

enum Direction {
  east,
  west,
  north,
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

enum Condition {
  superDeluxe,
  neW,
  good,
  old,
  structureOnly;

  String get arName {
    return switch (this) {
      superDeluxe => "سوبر ديلوكس",
      neW => "جديدة",
      good => "جيدة",
      old => "قديمة",
      structureOnly => "على العظم",
    };
  }
}

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
  govermentProperty,
  temporaryRegister;

  String get arName {
    return switch (this) {
      housingTitle => " طابو إسكان",
      sharesTitle => " طابو أسهم",
      greenTitle => "طابو أخضر",
      courtJudgement => "حكم محكمة",
      outrightSellContract => "عقد بيع قطعي",
      agriculturalTitle => "طابو زراعي",
      rightOfUse => "فروغ",
      govermentProperty => "أملاك دولة",
      temporaryRegister => "سجل مؤقت",
    };
  }
}

enum Features {
  solarPower,
  balcony,
  solarWater,
  elevator,
  parking,
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
