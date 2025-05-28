import 'package:aqaraty/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../enums/enums.dart';

class RealEstate extends Equatable {
  String? id;
  Types? type;
  PropertyType? propertyType;
  String? locationArea;
  String? locationMark;
  int price;
  int? floor;
  int rooms;
  bool iswithSalon;
  bool iswithSofa;
  int? area;
  List<Direction>? direction;
  OwnershipType? ownershipType;
  Condition? condition;
  String? customerName;
  String? customerPhone;
  String? officeName;
  String? officePhone;
  Furnishing? furnishing;
  bool isOffice;
  List<Features>? features = [];
  String? additionalInformation;
  List<String>? gallary;
  User? createdBy;
  RequestStatus? requestStatus;

  RealEstate({
    this.id,
    this.type,
    this.propertyType,
    this.locationArea,
    this.locationMark,
    this.condition,
    this.price = 0,
    this.floor,
    this.rooms = 0,
    this.iswithSalon = false,
    this.iswithSofa = false,
    this.area,
    this.direction,
    this.ownershipType,
    this.customerName,
    this.customerPhone,
    this.officeName,
    this.officePhone,
    this.furnishing,
    this.isOffice = false,
    this.features,
    this.additionalInformation,
    this.gallary,
    this.createdBy,
    this.requestStatus = RequestStatus.pending,
  });

  Future<ParseObject> realEstateToParseObject(RealEstate realEstate) async {
    // Create the base ParseObject
    final parseObject = ParseObject('real_estate');

    // Convert enum values to strings
    final typeString = realEstate.type?.toString().split('.').last;
    final propertyTypeString =
        realEstate.propertyType?.toString().split('.').last;
    final ownershipTypeString =
        realEstate.ownershipType?.toString().split('.').last;
    final conditionString = realEstate.condition?.toString().split('.').last;
    final furnishingString = realEstate.furnishing?.toString().split('.').last;
    final requestStatusString =
        RequestStatus.pending.toString().split('.').last;

    // Convert directions to ParseArray
    final directionsArray = realEstate.direction
        ?.map((dir) => dir.toString().split('.').last)
        .toList();

    // Convert features to ParseArray
    final featuresArray = realEstate.features
        ?.map((feature) => feature.toString().split('.').last)
        .toList();

    // Set all properties
    parseObject.set<String?>('type', typeString);
    parseObject.set<String?>('objectId', id);
    parseObject.set<String?>('propertyType', propertyTypeString);
    parseObject.set<String?>('locationArea', realEstate.locationArea);
    parseObject.set<String?>('locationMark', realEstate.locationMark);
    parseObject.set<int?>('price', realEstate.price);
    parseObject.set<int?>('floor', realEstate.floor);
    parseObject.set<int?>('rooms', realEstate.rooms);
    parseObject.set<bool?>('iswithSalon', realEstate.iswithSalon);
    parseObject.set<bool?>('iswithSofa', realEstate.iswithSofa);
    parseObject.set<int?>('area', realEstate.area);
    parseObject.set<List?>('direction', directionsArray);
    parseObject.set<String?>('ownershipType', ownershipTypeString);
    parseObject.set<String?>('condition', conditionString);
    parseObject.set<String?>('customerName', realEstate.customerName);
    parseObject.set<String?>('customerPhone', realEstate.customerPhone);
    parseObject.set<String?>('officeName', realEstate.officeName);
    parseObject.set<String?>('officePhone', realEstate.officePhone);
    parseObject.set<String?>('furnishing', furnishingString);
    parseObject.set<bool?>('isOffice', realEstate.isOffice);
    parseObject.set<List?>('features', featuresArray);
    parseObject.set<String?>(
        'additional_information', realEstate.additionalInformation);
    parseObject.set<List?>('gallary', realEstate.gallary);
    parseObject.set<String?>('requestStatus', requestStatusString);

    if (realEstate.createdBy == null) {
      final ParseUser currentUser = await ParseUser.currentUser() as ParseUser;
      parseObject.set('user', currentUser.toPointer());
    }

    return parseObject;
  }

  factory RealEstate.realEstateFromParseObject(ParseObject parseObject) {
    // Helper function to convert enum strings back to enum values
    T? enumFromString<T>(List<T> values, String? str) {
      if (str == null) return null;
      return values.firstWhere(
        (v) => v.toString().split('.').last == str,
        orElse: () => null as T,
      );
    }

    return RealEstate(
      id: parseObject.objectId,
      type: enumFromString(Types.values, parseObject.get<String>('type')),
      propertyType: enumFromString(
          PropertyType.values, parseObject.get<String>('propertyType')),
      locationArea: parseObject.get<String>('locationArea'),
      locationMark: parseObject.get<String>('locationMark'),
      price: parseObject.get<int>('price') ?? 0,
      floor: parseObject.get<int>('floor'),
      rooms: parseObject.get<int>('rooms') ?? 0,
      iswithSalon: parseObject.get<bool>('iswithSalon') ?? false,
      iswithSofa: parseObject.get<bool>('iswithSofa') ?? false,
      area: parseObject.get<int>('area'),
      direction: (parseObject.get<List<dynamic>>('direction') ?? [])
          .map((e) => enumFromString(Direction.values, e as String?))
          .whereType<Direction>()
          .toList(),
      ownershipType: enumFromString(
          OwnershipType.values, parseObject.get<String>('ownershipType')),
      condition: enumFromString(
          Condition.values, parseObject.get<String>('condition')),
      customerName: parseObject.get<String>('customerName'),
      customerPhone: parseObject.get<String>('customerPhone'),
      officeName: parseObject.get<String>('officeName'),
      officePhone: parseObject.get<String>('officePhone'),
      furnishing: enumFromString(
          Furnishing.values, parseObject.get<String>('furnishing')),
      isOffice: parseObject.get<bool>('isOffice') ?? false,
      features: (parseObject.get<List<dynamic>>('features') ?? [])
          .map((e) => enumFromString(Features.values, e as String?))
          .whereType<Features>()
          .toList(),
      additionalInformation: parseObject.get<String>('additional_information'),
      gallary: (parseObject.get<List<dynamic>>('gallary') ?? [])
          .map((e) => e as String)
          .toList(),
      createdBy: User.userFromParseUser(parseObject.get('user')!),
      requestStatus: enumFromString(
              RequestStatus.values, parseObject.get<String>('requestStatus')) ??
          RequestStatus.pending,
    );
  }

  String get getRoomsWithExtra {
    String room;
    if (rooms == 1) {
      room = "غرفة";
    } else if (rooms == 2) {
      room = "غرفتين";
    } else {
      room = "$rooms غرف";
    }
    if (iswithSalon) {
      room += " + صالون";
    }
    if (iswithSofa) {
      room += " + صوفا";
    }
    return room;
  }

  static RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String mathFunc(Match match) => '${match[1]},';

  String get getPrice =>
      "${price.toString().replaceAllMapped(reg, mathFunc)} ل.س";
  String? get getFloor => ordinalsAr(floor);

  RealEstate copyWith({
    String? id,
    Types? type,
    PropertyType? propertyType,
    String? locationArea,
    String? locationMark,
    int? price,
    int? floor,
    int? rooms,
    bool? iswithSalon,
    bool? iswithSofa,
    int? area,
    List<Direction>? direction,
    OwnershipType? ownershipType,
    Condition? condition,
    String? customerName,
    String? customerPhone,
    String? officeName,
    String? officePhone,
    Furnishing? furnishing,
    bool? isOffice,
    List<Features>? features,
    String? additionalInformation,
    List<String>? gallary,
    User? createdBy,
    RequestStatus? requestStatus,
  }) {
    return RealEstate(
      id: id ?? this.id,
      type: type ?? this.type,
      propertyType: propertyType ?? this.propertyType,
      locationArea: locationArea ?? this.locationArea,
      locationMark: locationMark ?? this.locationMark,
      price: price ?? this.price,
      floor: floor ?? this.floor,
      rooms: rooms ?? this.rooms,
      iswithSalon: iswithSalon ?? this.iswithSalon,
      iswithSofa: iswithSofa ?? this.iswithSofa,
      area: area ?? this.area,
      direction: direction ??
          (this.direction != null
              ? List<Direction>.from(this.direction!)
              : null),
      ownershipType: ownershipType ?? this.ownershipType,
      condition: condition ?? this.condition,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      officeName: officeName ?? this.officeName,
      officePhone: officePhone ?? this.officePhone,
      furnishing: furnishing ?? this.furnishing,
      isOffice: isOffice ?? this.isOffice,
      features: features ??
          (this.features != null ? List<Features>.from(this.features!) : null),
      additionalInformation:
          additionalInformation ?? this.additionalInformation,
      gallary: gallary ??
          (this.gallary != null ? List<String>.from(this.gallary!) : null),
      createdBy: createdBy ?? this.createdBy,
      requestStatus: requestStatus ?? this.requestStatus,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        propertyType,
        locationArea,
        locationMark,
        price,
        floor,
        rooms,
        iswithSalon,
        iswithSofa,
        area,
        direction,
        ownershipType,
        condition,
        customerName,
        customerPhone,
        officeName,
        officePhone,
        furnishing,
        isOffice,
        features,
        additionalInformation,
        gallary,
        createdBy,
        requestStatus,
      ];
}

// final realesatateSample = RealEstate(
//   id: "0",
//   type: Types.sell,
//   propertyType: PropertyType.apartment,
//   locationArea: "مساكن برزة",
//   locationMark: "حلف الجامع",
//   price: 20000000000,
//   floor: 9,
//   iswithSalon: true,
//   rooms: 2,
//   direction: [Direction.east, Direction.north],
//   ownershipType: OwnershipType.housingTitle,
//   customerName: "ابو علي",
//   customerPhone: "0964866245",
//   furnishing: Furnishing.full,
//   createdBy: User(id: "g"),
// );

String? ordinalsAr(int? num, {bool isFeminine = false}) {
  if (num == null) {
    return null;
  }
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
