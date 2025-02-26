import 'package:ard_resto_mobile_bnsp/business_logic/utils/navigate_screen_utils.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_colors.dart';
import 'package:ard_resto_mobile_bnsp/data/models/restaurant.dart';
import 'package:ard_resto_mobile_bnsp/presentation/components/flutter_maps_component.dart';
import 'package:ard_resto_mobile_bnsp/presentation/components/rating_resto_detail_component.dart';
import 'package:ard_resto_mobile_bnsp/presentation/screens/full_page_maps_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_defaults.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailRestaurantScreen extends StatefulWidget {
  const DetailRestaurantScreen({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  State<DetailRestaurantScreen> createState() => _DetailRestaurantScreenState();
}

class _DetailRestaurantScreenState extends State<DetailRestaurantScreen> {
  Alignment selectedAlignment = Alignment.topCenter;
  bool counterRotate = false;
  Size sizeScreen = Size.zero;

  late double latitude;
  late double longitude;

  Marker buildPin(LatLng point) => Marker(
        point: point,
        width: 60,
        height: 60,
        child: GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tapped existing marker'),
              duration: Duration(seconds: 1),
              showCloseIcon: true,
            ),
          ),
          child: const Icon(Icons.location_pin, size: 60, color: Colors.black),
        ),
      );

  @override
  Widget build(BuildContext context) {
    sizeScreen = MediaQuery.of(context).size;
    List<String> parts = widget.restaurant.location!.split(',');
    latitude = double.parse(parts[0].trim());
    longitude = double.parse(parts[1].trim());

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.secondary,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.secondary,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
        title: Text(
          'Detail #${widget.restaurant.name}',
          style: TextStyle(
            fontSize: 22,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.restaurant.imageUrl!,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDefaults.padding),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.restaurant.name!,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tentang Resto',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                  ),
                  Text(
                    widget.restaurant.description!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Lokasi Resto',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                  ),
                  Container(
                      height: 300,
                      width: sizeScreen.width,
                      child: Stack(
                        children: [
                          FlutterMapsComponent(
                            location: widget.restaurant.location!,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  nextScreen(
                                      context,
                                      FullPageMapsScreen(
                                          location:
                                              widget.restaurant.location!));
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
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.fullscreen)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 10),
                  RatingRestoDetailComponent(
                    totalStars: widget.restaurant.rating!,
                  ),
                  const Divider(thickness: 0.1),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: sizeScreen.width,
                    child: ElevatedButton(
                      onPressed: _launchMaps,
                      style: ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets.all(AppDefaults.padding * 1.2),
                        backgroundColor: AppColors.secondary,
                      ),
                      child: const Text(
                        'Navigasi ke Lokasi',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchMaps() async {
    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude";

    if (!await launchUrl(Uri.parse(googleMapsUrl))) {
      throw Exception('Could not launch $googleMapsUrl');
    }
  }
}
