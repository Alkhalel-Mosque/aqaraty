import 'package:aqaraty/local_data/condition.dart';
import 'package:aqaraty/local_data/direction.dart';
import 'package:aqaraty/local_data/features.dart';
import 'package:aqaraty/local_data/furnishing_1.dart';
import 'package:aqaraty/local_data/ownershipType.dart';
import 'package:aqaraty/local_data/property_type.dart';
import 'package:aqaraty/local_data/request_status.dart';
import 'package:aqaraty/local_data/types_local.dart';
import 'package:aqaraty/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../enums/enums.dart';

part 'real_estate.g.dart';

@HiveType(typeId: 0)
class RealEstate extends HiveObject with EquatableMixin {
  @HiveField(0)
  String? id;
  @HiveField(1)
  Types? type;
  @HiveField(2)
  PropertyType? propertyType;
  @HiveField(3)
  String? locationArea;
  @HiveField(4)
  String? locationMark;
  @HiveField(5)
  int price;
  @HiveField(6)
  int? floor;
  @HiveField(7)
  int rooms;
  @HiveField(8)
  bool iswithSalon;
  @HiveField(9)
  bool iswithRoof;
  @HiveField(10)
  bool iswithSofa;
  @HiveField(11)
  int? area;
  @HiveField(12)
  List<Direction>? direction;
  @HiveField(13)
  OwnershipType? ownershipType;
  @HiveField(14)
  Condition? condition;
  @HiveField(15)
  String? customerName;
  @HiveField(16)
  String? customerPhone;
  @HiveField(17)
  String? officeName;
  @HiveField(18)
  String? officePhone;
  @HiveField(19)
  Furnishing? furnishing;
  @HiveField(20)
  bool isOffice;
  @HiveField(21)
  List<Features>? features;
  @HiveField(22)
  String? additionalInformation;
  @HiveField(23)
  List<String>? gallary;
  @HiveField(24)
  String? createdById;
  @HiveField(25)
  RequestStatus? requestStatus;
  @HiveField(26)
  LatLng? coords;
  @HiveField(27)
  DateTime? createdAt;

  RealEstate({
    this.id,
    this.type,
    this.propertyType,
    this.locationArea,
    this.locationMark,
    this.condition,
    this.price = 0,
    this.floor,
    this.coords,
    this.rooms = 0,
    this.iswithRoof = false,
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
    this.createdById,
    this.createdAt,
    this.requestStatus = RequestStatus.pending,
  });

  Future<ParseObject> realEstateToParseObject(RealEstate realEstate) async {
    final parseObject = ParseObject('real_estate');

    final validGallery = realEstate.gallary?.where((url) {
      try {
        final uri = Uri.parse(url);
        return uri.isAbsolute &&
            (uri.scheme == 'http' || uri.scheme == 'https');
      } catch (_) {
        return false;
      }
    }).toList();

    parseObject.set<String?>(
        'type', realEstate.type?.toString().split('.').last);
    parseObject.set<String?>('objectId', realEstate.id);
    parseObject.set<String?>(
        'propertyType', realEstate.propertyType?.toString().split('.').last);
    parseObject.set<String?>('locationArea', realEstate.locationArea);
    parseObject.set<String?>('locationMark', realEstate.locationMark);
    parseObject.set<int?>('price', realEstate.price);
    parseObject.set<int?>('floor', realEstate.floor);
    parseObject.set<int?>('rooms', realEstate.rooms);
    parseObject.set<bool?>('iswithSalon', realEstate.iswithSalon);
    parseObject.set<bool?>('iswithSofa', realEstate.iswithSofa);
    parseObject.set<bool?>('iswithRoof', realEstate.iswithRoof);
    parseObject.set<int?>('area', realEstate.area);
    parseObject.set<List?>(
        'direction',
        realEstate.direction
            ?.map((dir) => dir.toString().split('.').last)
            .toList());
    parseObject.set<String?>(
        'ownershipType', realEstate.ownershipType?.toString().split('.').last);
    parseObject.set<String?>(
        'condition', realEstate.condition?.toString().split('.').last);
    parseObject.set<String?>('customerName', realEstate.customerName);
    parseObject.set<String?>('customerPhone', realEstate.customerPhone);
    parseObject.set<String?>('officeName', realEstate.officeName);
    parseObject.set<String?>('officePhone', realEstate.officePhone);
    parseObject.set<String?>(
        'furnishing', realEstate.furnishing?.toString().split('.').last);
    parseObject.set<bool?>('isOffice', realEstate.isOffice);
    parseObject.set<List?>(
        'features',
        realEstate.features
            ?.map((feature) => feature.toString().split('.').last)
            .toList());
    parseObject.set<String?>(
        'additional_information', realEstate.additionalInformation);
    parseObject.set<List<String>?>('gallary', validGallery);
    parseObject.set<String?>(
        'requestStatus',
        realEstate.requestStatus?.toString().split('.').last ??
            RequestStatus.pending.toString().split('.').last);

    if (realEstate.coords != null) {
      parseObject.set<ParseGeoPoint?>(
        'mapLocation',
        ParseGeoPoint(
            latitude: realEstate.coords!.latitude,
            longitude: realEstate.coords!.longitude),
      );
    }

    if (realEstate.createdById == null) {
      final currentUser = await ParseUser.currentUser() as ParseUser?;
      if (currentUser != null) {
        parseObject.set('user', currentUser.toPointer());
      }
    } else {
      final user = ParseUser.forQuery()..objectId = realEstate.createdById;
      parseObject.set('user', user.toPointer());
    }

    return parseObject;
  }

  factory RealEstate.realEstateFromParseObject(ParseObject parseObject) {
    T? enumFromString<T>(List<T> values, String? str) {
      if (str == null) return null;
      return values.firstWhere(
        (v) => v.toString().split('.').last == str,
        orElse: () => null as T,
      );
    }

    final geoPoint = parseObject.get<ParseGeoPoint?>('mapLocation');
    final gallery = (parseObject.get<List<dynamic>>('gallary') ?? [])
        .map((e) => e as String?)
        .where((url) => url != null && Uri.tryParse(url)?.isAbsolute == true)
        .toList();

    return RealEstate(
      id: parseObject.objectId,
      type: enumFromString(Types.values, parseObject.get<String>('type')),
      propertyType: enumFromString(
          PropertyType.values, parseObject.get<String>('propertyType')),
      locationArea: parseObject.get<String>('locationArea'),
      locationMark: parseObject.get<String>('locationMark'),
      coords: geoPoint == null
          ? null
          : LatLng(geoPoint.latitude, geoPoint.longitude),
      price: parseObject.get<int>('price') ?? 0,
      floor: parseObject.get<int>('floor'),
      rooms: parseObject.get<int>('rooms') ?? 0,
      iswithSalon: parseObject.get<bool>('iswithSalon') ?? false,
      iswithRoof: parseObject.get<bool>('iswithRoof') ?? false,
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
      gallary: gallery.cast<String>(),
      createdById: parseObject.get<ParseUser>('user')?.objectId,
      createdAt: parseObject.createdAt,
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

  static final RegExp _priceRegExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String _priceFormat(Match match) => '${match[1]},';

  String get getPrice =>
      "${price.toString().replaceAllMapped(_priceRegExp, _priceFormat)} ل.س";

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
    bool? iswithRoof,
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
    String? createdById,
    RequestStatus? requestStatus,
    LatLng? coords,
    DateTime? createdAt,
  }) {
    return RealEstate(
      id: id ?? this.id,
      type: type ?? this.type,
      propertyType: propertyType ?? this.propertyType,
      locationArea: locationArea ?? this.locationArea,
      locationMark: locationMark ?? this.locationMark,
      price: price ?? this.price,
      floor: floor ?? this.floor,
      coords: coords ?? this.coords,
      rooms: rooms ?? this.rooms,
      iswithRoof: iswithRoof ?? this.iswithRoof,
      iswithSalon: iswithSalon ?? this.iswithSalon,
      iswithSofa: iswithSofa ?? this.iswithSofa,
      area: area ?? this.area,
      direction: direction ??
          (this.direction != null ? List.from(this.direction!) : null),
      ownershipType: ownershipType ?? this.ownershipType,
      condition: condition ?? this.condition,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      officeName: officeName ?? this.officeName,
      officePhone: officePhone ?? this.officePhone,
      furnishing: furnishing ?? this.furnishing,
      isOffice: isOffice ?? this.isOffice,
      features: features ??
          (this.features != null ? List.from(this.features!) : null),
      additionalInformation:
          additionalInformation ?? this.additionalInformation,
      gallary:
          gallary ?? (this.gallary != null ? List.from(this.gallary!) : null),
      createdById: createdById ?? this.createdById,
      requestStatus: requestStatus ?? this.requestStatus,
      createdAt: createdAt ?? this.createdAt,
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
        iswithRoof,
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
        createdById,
        requestStatus,
        coords,
        createdAt,
      ];
}

Future<ParseUser?> fetchUserById(String? id) async {
  if (id == null) return null;

  final query = QueryBuilder<ParseUser>(ParseUser.forQuery())
    ..whereEqualTo('objectId', id);

  final response = await query.query();

  if (response.success &&
      response.results != null &&
      response.results!.isNotEmpty) {
    return response.results!.first as ParseUser;
  }
  return null;
}

String? ordinalsAr(int? num, {bool isFeminine = false}) {
  if (num == null) return null;

  if (num == -2) return "قبو ثاني";
  if (num == -1) return "قبو أول";
  if (num == 0) return "الطابق الأرضي";

  num %= 100;
  const the = "الطابق ال";
  final unit = num % 10;

  final ordinals = [
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
  ];

  final ordinal = the + ordinals[num == 10 ? num : unit];
  final female = isFeminine ? "ة" : "";
  final ones = (unit == 1 ? "${the}حادي" : ordinal) + female;

  if (num < 11) {
    return ordinal + (isFeminine && num == 1 ? "ى" : female);
  } else if (num < 20) {
    return "$ones عشر$female";
  } else {
    final tens = [
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
    ];
    return "${unit != 0 ? "$ones و" : ""}ال${tens[num ~/ 10]}ون";
  }
}

final List<String> locations = [
  "مساكن برزة",
  "برزة",
  "حاميش",
  "القابون",
  "أبو جرش",
  "ركن الدين",
  "معربا",
];
