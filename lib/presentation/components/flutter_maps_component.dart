import 'package:ard_resto_mobile_bnsp/business_logic/utils/navigate_screen_utils.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_path_assets.dart';
import 'package:ard_resto_mobile_bnsp/presentation/screens/full_page_maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

class FlutterMapsComponent extends StatefulWidget {
  const FlutterMapsComponent({super.key, required this.location});

  final String location;

  @override
  State<FlutterMapsComponent> createState() => _FlutterMapsComponentState();
}

class _FlutterMapsComponentState extends State<FlutterMapsComponent> {
  Size sizeScreen = Size.zero;
  late double latitude;
  late double longitude;

  double minZoom = 1;
  double maxZoom = 18;

  @override
  Widget build(BuildContext context) {
    sizeScreen = MediaQuery.of(context).size;
    List<String> parts = widget.location!.split(',');
    latitude = double.parse(parts[0].trim());
    longitude = double.parse(parts[1].trim());

    final _tileProvider = FMTCTileProvider(
      stores: const {'mapStore': BrowseStoreStrategy.readUpdateCreate},
    );

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FlutterMap(
            options: MapOptions(
              keepAlive: true,
              initialCenter: LatLng(latitude, longitude),
              initialZoom: 18.0,
              interactionOptions: const InteractionOptions(
                flags: ~InteractiveFlag.doubleTapZoom,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'http://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}',
                tileProvider: _tileProvider,
              ),
              FlutterMapZoomButtons(),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(latitude, longitude),
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        "${AppPathAssets.icons}marker_restaurant.png",
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FlutterMapZoomButtons extends StatelessWidget {
  FlutterMapZoomButtons({super.key});

  late double minZoom = 1;
  late double maxZoom = 20;

  @override
  Widget build(BuildContext context) {
    final controller = MapController.of(context);
    final camera = MapCamera.of(context);
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                final zoom = min(camera.zoom + 1, maxZoom);
                controller.move(camera.center, zoom);
              },
              child: Container(
                width: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(3),
                    topRight: Radius.circular(3),
                  ),
                ),
                child: Padding(
                    padding: EdgeInsets.all(8.0), child: Icon(Icons.add)),
              ),
            ),
            InkWell(
              onTap: () {
                final zoom = max(camera.zoom - 1, minZoom);
                controller.move(camera.center, zoom);
              },
              child: Container(
                width: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    child: Icon(Icons.minimize)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
