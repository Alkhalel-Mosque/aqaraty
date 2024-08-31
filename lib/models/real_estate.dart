import '../enums/enums.dart';

class RealEstate {
  int? id;
  Types? type;
  PropertyType? propertyType;
  String? locationArea;
  String? locationMark;
  int? minPrice;
  int? maxPrice;
  int? floor;
  int? minRooms;
  int? maxRooms;
  bool iswithSalon;
  bool iswithSofa;
  int? minArea;
  int? maxArea;
  List<Direction>? direction;
  OwnershipType? ownershipType;
  String? customerName;
  String? customerPhone;
  String? officeName;
  String? officePhone;
  Furnishing? furnishing;
  bool? isOffice;
  List<Features>? features;
  String? description;
  List<String>? gallary;
  int? createdBy;

  RealEstate({
    this.id,
    this.type,
    this.propertyType,
    this.locationArea,
    this.locationMark,
    this.minPrice,
    this.maxPrice,
    this.floor,
    this.minRooms,
    this.maxRooms,
    this.iswithSalon = false,
    this.iswithSofa = false,
    this.minArea,
    this.maxArea,
    this.direction,
    this.ownershipType,
    this.customerName,
    this.customerPhone,
    this.officeName,
    this.officePhone,
    this.furnishing,
    this.isOffice = false,
    this.features,
    this.description,
    this.gallary,
    this.createdBy,
  });

  String get getRoomsWithExtra {
    String rooms;
    if (minRooms == 1) {
      rooms = "غرفة";
    } else if (minRooms == 2) {
      rooms = "غرفتين";
    } else {
      rooms = "$minRooms غرف";
    }
    if (iswithSalon) {
      rooms += " + صالون";
    }
    if (iswithSofa) {
      rooms += " + صوفا";
    }
    return rooms;
  }

  static RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String mathFunc(Match match) => '${match[1]},';

  String get getPrice =>
      "${minPrice.toString().replaceAllMapped(reg, mathFunc)} ل.س";
  String get getFloor => ordinalsAr(floor!);
}

final realesatateSample = RealEstate(
  id: 0,
  type: Types.sell,
  propertyType: PropertyType.apartment,
  locationArea: "مساكن برزة",
  locationMark: "حلف الجامع",
  minPrice: 20000000000,
  floor: 9,
  iswithSalon: true,
  minRooms: 2,
  direction: [Direction.east, Direction.north],
  ownershipType: OwnershipType.housingTitle,
  customerName: "ابو علي",
  customerPhone: "0964866245",
  furnishing: Furnishing.full,
  createdBy: 5,
);

String ordinalsAr(int num, {bool isFeminine = false}) {
  if (num == -2) {
    return " قبو ثاني";
  } else if (num == -1) {
    return " قبو أول";
  } else if (num == 0) {
    return " الطابق الأرضي";
  }
  num %= 100; // only handle the lowest 2 digits (1-99), ignore others
  String the =
      " الطابق ال"; // set this to "" if you don't want the output prefixed with letters "ال"
  int unit = num % 10;
  String ordinal = the +
      [
        "",
        "أول",
        "ثاني",
        "ثالث",
        "رابع",
        "خامس",
        "سادس",
        "سابع",
        "ثامن",
        "تاسع",
        "عاشر"
      ][num == 10 ? num : unit]; // letters for lower part of ordinal string
  String female = isFeminine ? "ة" : ""; // add letter "ة" if Feminine
  String ones = (unit == 1 ? "$theحادي" : ordinal) +
      female; // special cases for 21, 31, 41, etc.

  if (num < 11) {
    return ordinal + (isFeminine && num == 1 ? "ى" : female); // from 1 to 10
  } else if (num < 20) {
    return "$ones عشر$female"; // from 11 to 19
  } else {
    return "${unit != 0 ? "$ones و" : ""}ال${[
      "",
      "",
      "عشر",
      "ثلاث",
      "أربع",
      "خمس",
      "ست",
      "سبع",
      "ثمان",
      "تسع"
    ][(num ~/ 10)]}ون";
  }
}
