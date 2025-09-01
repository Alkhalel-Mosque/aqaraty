import 'dart:io';

import 'package:aqaraty/api/local_data/condition.dart';
import 'package:aqaraty/api/local_data/currency2.dart';
import 'package:aqaraty/api/local_data/direction.dart';
import 'package:aqaraty/api/local_data/features.dart';
import 'package:aqaraty/api/local_data/furnishing.dart';
import 'package:aqaraty/api/local_data/ownershipType.dart';
import 'package:aqaraty/api/local_data/property_type.dart';
import 'package:aqaraty/api/local_data/request_status.dart';
import 'package:aqaraty/api/local_data/types_local.dart';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

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
  int? price;
  @HiveField(6)
  int? floor;
  @HiveField(7)
  int? rooms;
  @HiveField(8)
  bool? iswithSalon;
  @HiveField(9)
  bool? iswithRoof;
  @HiveField(10)
  bool? iswithSofa;
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
  List<String>? galleryImageIds;
  @HiveField(24)
  String? createdById;
  @HiveField(25)
  RequestStatus? requestStatus;
  @HiveField(26)
  LatLng? coords;
  @HiveField(27)
  DateTime? createdAt;
  @HiveField(28)
  List<String>? localGalleryImagePaths;
  @HiveField(29)
  Currency? currency;

  RealEstate({
    this.id,
    this.type,
    this.propertyType,
    this.locationArea,
    this.locationMark,
    this.condition,
    this.price,
    this.floor,
    this.coords,
    this.rooms,
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
    this.galleryImageIds,
    this.createdById,
    this.createdAt,
    this.requestStatus = RequestStatus.pending,
    List<String>? localGalleryImagePaths,
    this.currency = Currency.SYP,
  });

  Future<ParseObject> realEstateToParseObject(RealEstate realEstate) async {
    final parseObject = ParseObject('real_estate');
    if (realEstate.id != null) {
      parseObject.objectId = realEstate.id;
    }

    parseObject.set<List<String>?>('gellary', realEstate.galleryImageIds ?? []);
    parseObject.set<String>(
        'currency', (realEstate.currency).toString().split('.').last);
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

    final gallery = (parseObject.get<List<dynamic>>('gellary') ?? [])
        .whereType<String>()
        .where((url) => Uri.tryParse(url)?.isAbsolute == true)
        .toList();

    String? createdById;
    final userField = parseObject.get('user');
    if (userField is ParseUser) {
      createdById = userField.objectId;
    } else if (userField is ParseObject) {
      createdById = userField.objectId;
    } else if (userField is Map) {
      createdById = userField['objectId'] as String?;
    }

    return RealEstate(
      currency: enumFromString(
              Currency.values, parseObject.get<String>('currency')) ??
          Currency.SYP,
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
      galleryImageIds: gallery,
      createdById: createdById,
      createdAt: parseObject.createdAt,
      requestStatus: enumFromString(
              RequestStatus.values, parseObject.get<String>('requestStatus')) ??
          RequestStatus.pending,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'currency': currency.toString().split('.').last,
      'id': id,
      'type': type?.toString().split('.').last,
      'propertyType': propertyType?.toString().split('.').last,
      'locationArea': locationArea,
      'locationMark': locationMark,
      'price': price,
      'floor': floor,
      'rooms': rooms,
      'iswithSalon': iswithSalon,
      'iswithRoof': iswithRoof,
      'iswithSofa': iswithSofa,
      'area': area,
      'direction': direction?.map((d) => d.toString().split('.').last).toList(),
      'ownershipType': ownershipType?.toString().split('.').last,
      'condition': condition?.toString().split('.').last,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'officeName': officeName,
      'officePhone': officePhone,
      'furnishing': furnishing?.toString().split('.').last,
      'isOffice': isOffice,
      'features': features?.map((f) => f.toString().split('.').last).toList(),
      'additionalInformation': additionalInformation,
      'galleryImageIds': galleryImageIds,
      'createdById': createdById,
      'requestStatus': requestStatus?.toString().split('.').last,
      'coords': coords != null
          ? {'lat': coords!.latitude, 'lng': coords!.longitude}
          : null,
      'createdAt': createdAt?.toIso8601String(),
      'localGalleryImagePaths': localGalleryImagePaths,
    };
  }

  factory RealEstate.fromJson(Map<String, dynamic> json) {
    T? enumFromString<T>(List<T> values, String? str) {
      if (str == null) return null;
      return values.firstWhere(
        (v) => v.toString().split('.').last == str,
        orElse: () => null as T,
      );
    }

    return RealEstate(
      id: json['id'],
      type: enumFromString(Types.values, json['type']),
      propertyType: enumFromString(PropertyType.values, json['propertyType']),
      locationArea: json['locationArea'],
      locationMark: json['locationMark'],
      price: json['price'] ?? 0,
      floor: json['floor'],
      rooms: json['rooms'] ?? 0,
      iswithSalon: json['iswithSalon'] ?? false,
      iswithRoof: json['iswithRoof'] ?? false,
      iswithSofa: json['iswithSofa'] ?? false,
      area: json['area'],
      direction: (json['direction'] as List?)
          ?.map((e) => enumFromString(Direction.values, e))
          .whereType<Direction>()
          .toList(),
      ownershipType:
          enumFromString(OwnershipType.values, json['ownershipType']),
      condition: enumFromString(Condition.values, json['condition']),
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      officeName: json['officeName'],
      officePhone: json['officePhone'],
      furnishing: enumFromString(Furnishing.values, json['furnishing']),
      isOffice: json['isOffice'] ?? false,
      features: (json['features'] as List?)
          ?.map((e) => enumFromString(Features.values, e))
          .whereType<Features>()
          .toList(),
      additionalInformation: json['additionalInformation'],
      galleryImageIds: (json['galleryImageIds'] as List?)?.cast<String>(),
      createdById: json['createdById'],
      requestStatus:
          enumFromString(RequestStatus.values, json['requestStatus']) ??
              RequestStatus.pending,
      coords: json['coords'] != null
          ? LatLng(json['coords']['lat'], json['coords']['lng'])
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      localGalleryImagePaths:
          (json['localGalleryImagePaths'] as List?)?.cast<String>(),
      currency:
          enumFromString(Currency.values, json['currency']) ?? Currency.SYP,
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
    if (iswithSalon == true) {
      room += " + صالون";
    }
    if (iswithSofa == true) {
      room += " + صوفا";
    }
    if (iswithRoof == true) {
      room += " + سطح";
    }
    return room;
  }

  static final RegExp _priceRegExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String _priceFormat(Match match) => '${match[1]},';

  String get getPrice =>
      "${price.toString().replaceAllMapped(_priceRegExp, _priceFormat)} ل.س";

  String? get getFloor => ordinalsAr(floor);

  RealEstate copyWith({
    Object? id = unset,
    Object? type = unset,
    Object? propertyType = unset,
    Object? locationArea = unset,
    Object? locationMark = unset,
    Object? price = unset,
    Object? floor = unset,
    Object? rooms = unset,
    Object? iswithSalon = unset,
    Object? iswithSofa = unset,
    Object? iswithRoof = unset,
    Object? area = unset,
    Object? direction = unset,
    Object? ownershipType = unset,
    Object? condition = unset,
    Object? customerName = unset,
    Object? customerPhone = unset,
    Object? officeName = unset,
    Object? officePhone = unset,
    Object? furnishing = unset,
    Object? isOffice = unset,
    Object? features = unset,
    Object? additionalInformation = unset,
    Object? galleryImageIds = unset,
    Object? createdById = unset,
    Object? requestStatus = unset,
    Object? coords = unset,
    Object? createdAt = unset,
    Object? localGalleryImagePaths = unset,
    Object? currency = unset,
  }) {
    return RealEstate(
      id: id is Unset ? this.id : id as String?,
      type: type is Unset ? this.type : type as Types?,
      propertyType: propertyType is Unset
          ? this.propertyType
          : propertyType as PropertyType?,
      locationArea:
          locationArea is Unset ? this.locationArea : locationArea as String?,
      locationMark:
          locationMark is Unset ? this.locationMark : locationMark as String?,
      price: price is Unset ? this.price : price as int?,
      floor: floor is Unset ? this.floor : floor as int?,
      rooms: rooms is Unset ? this.rooms : rooms as int?,
      iswithSalon:
          iswithSalon is Unset ? this.iswithSalon : iswithSalon as bool?,
      iswithSofa: iswithSofa is Unset ? this.iswithSofa : iswithSofa as bool?,
      iswithRoof: iswithRoof is Unset ? this.iswithRoof : iswithRoof as bool?,
      area: area is Unset ? this.area : area as int?,
      direction:
          direction is Unset ? this.direction : direction as List<Direction>?,
      ownershipType: ownershipType is Unset
          ? this.ownershipType
          : ownershipType as OwnershipType?,
      condition: condition is Unset ? this.condition : condition as Condition?,
      customerName:
          customerName is Unset ? this.customerName : customerName as String?,
      customerPhone: customerPhone is Unset
          ? this.customerPhone
          : customerPhone as String?,
      officeName: officeName is Unset ? this.officeName : officeName as String?,
      officePhone:
          officePhone is Unset ? this.officePhone : officePhone as String?,
      furnishing:
          furnishing is Unset ? this.furnishing : furnishing as Furnishing?,
      isOffice: isOffice is Unset ? this.isOffice : isOffice as bool,
      features: features is Unset ? this.features : features as List<Features>?,
      additionalInformation: additionalInformation is Unset
          ? this.additionalInformation
          : additionalInformation as String?,
      galleryImageIds: galleryImageIds is Unset
          ? this.galleryImageIds
          : galleryImageIds as List<String>?,
      createdById:
          createdById is Unset ? this.createdById : createdById as String?,
      requestStatus: requestStatus is Unset
          ? this.requestStatus
          : requestStatus as RequestStatus?,
      coords: coords is Unset ? this.coords : coords as LatLng?,
      createdAt: createdAt is Unset ? this.createdAt : createdAt as DateTime?,
      localGalleryImagePaths: localGalleryImagePaths is Unset
          ? this.localGalleryImagePaths
          : localGalleryImagePaths as List<String>?,
      currency: currency is Unset ? this.currency : currency as Currency?,
    );
  }

  Future<List<File>> getLocalImageFiles() async {
    if (localGalleryImagePaths == null || localGalleryImagePaths!.isEmpty) {
      return [];
    }

    final files = <File>[];
    for (final path in localGalleryImagePaths!) {
      final file = File(path);
      if (await file.exists()) {
        files.add(file);
      }
    }
    return files;
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
        galleryImageIds,
        createdById,
        requestStatus,
        coords,
        createdAt,
        localGalleryImagePaths,
        currency
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
    final first = response.results!.first;
    if (first is ParseUser) {
      return first;
    } else if (first is ParseObject) {
      final user = ParseUser(
        first.get<String>('username') ?? '',
        '',
        first.get<String>('email') ?? '',
      );
      user.objectId = first.objectId;
      return user;
    }
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

class Unset {
  const Unset();
}

/// Sentinel value representing an unset value in copyWith
const unset = Unset();
