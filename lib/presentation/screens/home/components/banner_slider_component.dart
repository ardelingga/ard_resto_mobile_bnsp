import 'package:ard_resto_mobile_bnsp/data/constants/app_colors.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_defaults.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_path_assets.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class BannerSliderComponent extends StatefulWidget {
  const BannerSliderComponent({super.key});

  @override
  State<BannerSliderComponent> createState() => _BannerSliderComponentState();
}

class _BannerSliderComponentState extends State<BannerSliderComponent> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _current = 0;

  List<String> get imagesBannerSlider => [
    "${AppPathAssets.images}sliders/image_banner_01.png",
    "${AppPathAssets.images}sliders/image_banner_02.png",
    "${AppPathAssets.images}sliders/image_banner_03.png",
    "${AppPathAssets.images}sliders/image_banner_04.png",
    "${AppPathAssets.images}sliders/image_banner_05.png",
  ];

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDefaults.radius),
              child: CarouselSlider.builder(
                carouselController: _controller,
                itemCount: imagesBannerSlider.length,
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  viewportFraction: 1.0,
                  initialPage: 0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  scrollDirection: Axis.horizontal,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                ),
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                    Container(
                      width: sizeScreen.width,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                      ),
                      child: Image.asset(
                        imagesBannerSlider[itemIndex],
                        fit: BoxFit.cover,
                      ),
                    ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imagesBannerSlider.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == entry.key ? Colors.black.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.9)
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
