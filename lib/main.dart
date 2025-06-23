import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../aqaraty.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  await initialServer();
  runApp(const ProviderScope(child: Aqaraty()));
}

Future<void> initialServer() async {

  WidgetsFlutterBinding.ensureInitialized();
  
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
