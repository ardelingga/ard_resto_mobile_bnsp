import 'package:ard_resto_mobile_bnsp/data/constants/app_colors.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_defaults.dart';
import 'package:ard_resto_mobile_bnsp/presentation/components/flutter_maps_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class FullPageMapsScreen extends StatefulWidget {
  const FullPageMapsScreen({
    super.key,
    required this.location,
  });

  final String location;

  @override
  State<FullPageMapsScreen> createState() => _FullPageMapsScreenState();
}

class _FullPageMapsScreenState extends State<FullPageMapsScreen> {
  Size sizeScreen = Size.zero;

  late double latitude;
  late double longitude;

  @override
  Widget build(BuildContext context) {
    sizeScreen = MediaQuery.of(context).size;
    double sttsbarHeight = MediaQuery.of(context).padding.top;
    double appbarHeight = AppBar().preferredSize.height;

    List<String> parts = widget.location!.split(',');
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
        title: Text(
          'Detail Map Lokasi',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )
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
      ),
      body: SizedBox(
        width: sizeScreen.width,
        height: sizeScreen.height,
        child: Stack(
          children: [
            FlutterMapsComponent(
              location: widget.location,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: SizedBox(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _launchMaps() async {
    final String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude";
    if (!await launchUrl(Uri.parse(googleMapsUrl))) {
      throw Exception('Could not launch $googleMapsUrl');
    }
  }
}
