import 'package:aqaraty/local_data/condition.dart';
import 'package:aqaraty/local_data/direction.dart';
import 'package:aqaraty/local_data/features.dart';
import 'package:aqaraty/local_data/furnishing_1.dart';
import 'package:aqaraty/local_data/latlng_adapter.dart';
import 'package:aqaraty/local_data/ownershipType.dart';
import 'package:aqaraty/local_data/property_type.dart';
import 'package:aqaraty/local_data/request_status.dart';
import 'package:aqaraty/local_data/types_local.dart';
import 'package:aqaraty/models/real_estate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import '../aqaraty.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  await initialServer();

  runApp(const ProviderScope(child: Aqaraty()));
}

Future<void> initialServer() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  Hive.registerAdapter(TypesAdapter());
  Hive.registerAdapter(RealEstateAdapter());

  Hive.registerAdapter(PropertyTypeAdapter());
  Hive.registerAdapter(DirectionAdapter());
  Hive.registerAdapter(OwnershipTypeAdapter());
  Hive.registerAdapter(ConditionAdapter());
  Hive.registerAdapter(FurnishingAdapter());
  Hive.registerAdapter(FeaturesAdapter());
  Hive.registerAdapter(RequestStatusAdapter());
  Hive.registerAdapter(LatLngAdapter());

  await Hive.openBox<RealEstate>('real_estates');
  await Hive.openBox<RealEstate>('pending_real_estates');

  const keyApplicationId = 'hhfftwGWHUZ4xDgoEveepbg8D25dUZqMDQJtvRp7';
  const keyClientKey = 'FOGdXmYSVKCLvyWFahPPUad64IgiLKAORrg68Z5G';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
  );
}
