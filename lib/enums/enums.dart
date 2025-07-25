// enum Types {
//   sell,
//   rentOut,
//   buy,
//   rent;

// // bool get isSellOrRentOut=>;
//   bool get isBuyOrSell => this == sell || this == buy;
//   bool get isOffer => this == sell || this == rentOut;
//   bool get isRequest => this == rent || this == buy;

//   String get arName {
//     return switch (this) {
//       sell => "للبيع",
//       buy => "للشراء",
//       rent => "للاستئجاء",
//       rentOut => "للإيجار",
//     };
//   }

//   static Types getFromString(String string) {
//     return switch (string) {
//       "عرض بيع" => sell,
//       "طلب شراء" => buy,
//       "طلب استئجار" => rent,
//       "عرض إيجار" => rentOut,
//       String() => throw UnimplementedError(),
//     };
//   }

//   String get arNameTitle {
//     return switch (this) {
//       sell => "عرض بيع",
//       buy => "طلب شراء",
//       rent => "طلب استئجار",
//       rentOut => "عرض إيجار",
//     };
//   }
// }

// enum Furnishing {
//   full,
//   semi,
//   none;

//   String get arName {
//     return switch (this) {
//       full => "مفروش",
//       semi => "نصف مفروش",
//       none => "غير مفروش",
//     };
//   }

//   static Furnishing getFromString(String string) {
//     return switch (string) {
//       "مفروش" => full,
//       "نصف مفروش" => semi,
//       "غير مفروش" => none,
//       String() => throw UnimplementedError(),
//     };
//   }
// }

// enum Direction {
//   east,
//   west,
//   north,
//   south;

//   String get arName {
//     return switch (this) {
//       east => "شرقي",
//       west => "غربي",
//       north => "شمالي",
//       south => "جنوبي",
//     };
//   }

//   static Direction getFromString(String string) {
//     return switch (string) {
//       "شرقي" => east,
//       "غربي" => west,
//       "شمالي" => north,
//       "جنوبي" => south,
//       String() => throw UnimplementedError(),
//     };
//   }
// }

// enum Condition {
//   superDeluxe,
//   neW,
//   good,
//   old,
//   structureOnly;

//   static Condition getFromString(String string) {
//     return switch (string) {
//       "سوبر ديلوكس" => Condition.superDeluxe,
//       "جديدة" => Condition.neW,
//       "جيدة" => Condition.good,
//       "قديمة" => Condition.old,
//       "على العظم" => Condition.structureOnly,
//       _ => throw ArgumentError('Unknown condition string: $string'),
//     };
//   }

//   String get arName {
//     return switch (this) {
//       Condition.superDeluxe => "سوبر ديلوكس",
//       Condition.neW => "جديدة",
//       Condition.good => "جيدة",
//       Condition.old => "قديمة",
//       Condition.structureOnly => "على العظم",
//     };
//   }
// }

// enum PropertyType {
//   apartment,
//   shop,
//   office,
//   farm,
//   roof,
//   annex,
//   villa;

//   static PropertyType getFromString(String string) {
//     return switch (string) {
//       "شقة" => PropertyType.apartment,
//       "سطح" => PropertyType.roof,
//       "ملحق" => PropertyType.annex,
//       "محل" => PropertyType.shop,
//       "مكتب" => PropertyType.office,
//       "مزرعة" => PropertyType.farm,
//       "فيلا" => PropertyType.villa,
//       _ => throw ArgumentError('Unknown property type string: $string'),
//     };
//   }

//   String get arName {
//     return switch (this) {
//       PropertyType.apartment => "شقة",
//       PropertyType.shop => "محل",
//       PropertyType.annex => "ملحق",
//       PropertyType.roof => "سطح",
//       PropertyType.office => "مكتب",
//       PropertyType.farm => "مزرعة",
//       PropertyType.villa => "فيلا",
//     };
//   }
// }

// enum OwnershipType {
//   housingTitle,
//   sharesTitle,
//   greenTitle,
//   courtJudgement,
//   outrightSellContract,
//   agriculturalTitle,
//   rightOfUse,
//   govermentProperty,
//   temporaryRegister;

//   static OwnershipType getFromString(String string) {
//     return switch (string.trim()) {
//       // Added trim() to handle whitespace
//       "طابو إسكان" => OwnershipType.housingTitle,
//       "طابو أسهم" => OwnershipType.sharesTitle,
//       "طابو أخضر" => OwnershipType.greenTitle,
//       "حكم محكمة" => OwnershipType.courtJudgement,
//       "عقد بيع قطعي" => OwnershipType.outrightSellContract,
//       "طابو زراعي" => OwnershipType.agriculturalTitle,
//       "فروغ" => OwnershipType.rightOfUse,
//       "أملاك دولة" => OwnershipType.govermentProperty,
//       "سجل مؤقت" => OwnershipType.temporaryRegister,
//       _ => throw ArgumentError('Unknown ownership type string: $string'),
//     };
//   }

//   String get arName {
//     return switch (this) {
//       OwnershipType.housingTitle => "طابو إسكان",
//       OwnershipType.sharesTitle => "طابو أسهم",
//       OwnershipType.greenTitle => "طابو أخضر",
//       OwnershipType.courtJudgement => "حكم محكمة",
//       OwnershipType.outrightSellContract => "عقد بيع قطعي",
//       OwnershipType.agriculturalTitle => "طابو زراعي",
//       OwnershipType.rightOfUse => "فروغ",
//       OwnershipType.govermentProperty => "أملاك دولة",
//       OwnershipType.temporaryRegister => "سجل مؤقت",
//     };
//   }
// }

// enum Features {
//   solarPower,
//   balcony,
//   solarWater,
//   elevator,
//   parking,
//   pool;

//   String get arName {
//     return switch (this) {
//       solarPower => "طاقة شمسية",
//       balcony => "برندة",
//       solarWater => "سخان شمسي",
//       elevator => "مصعد",
//       parking => "مرآب",
//       pool => "مسبح",
//     };
//   }
// }

// enum RequestStatus {
//   pending,
//   complete,
//   canceled;

//   static RequestStatus getFromString(String string) {
//     return switch (string.trim()) {
//       "معلق" => RequestStatus.pending,
//       "مكتمل" => RequestStatus.complete,
//       "ملغى" => RequestStatus.canceled,
//       _ => throw ArgumentError('Unknown request status string: $string'),
//     };
//   }

//   String get arName {
//     return switch (this) {
//       pending => "معلق",
//       complete => "مكتمل",
//       canceled => "ملغى",
//     };
//   }
// }
