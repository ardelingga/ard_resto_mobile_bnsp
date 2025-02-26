import 'package:ard_resto_mobile_bnsp/app.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Caching Map
  await FMTCObjectBoxBackend().initialise();
  await FMTCStore('mapStore').manage.create();

  runApp(App());
}
