import 'package:ard_resto_mobile_bnsp/business_logic/utils/navigate_screen_utils.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_colors.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_defaults.dart';
import 'package:ard_resto_mobile_bnsp/data/models/restaurant.dart';
import 'package:ard_resto_mobile_bnsp/presentation/screens/restaurants/detail_restaurant_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ItemRestaurantGridView extends StatelessWidget {
  const ItemRestaurantGridView({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.scaffoldBackground,
      borderRadius: AppDefaults.borderRadius,
      child: InkWell(
        onTap: () {
          // Navigator.pushNamed(context, AppRoutes.bundleProduct);
          nextScreen(
            context,
            DetailRestaurantScreen(
              restaurant: restaurant,
            ),
          );
        },
        borderRadius: AppDefaults.borderRadius,
        child: Container(
          width: 176,
          decoration: BoxDecoration(
            borderRadius: AppDefaults.borderRadius,
            color: AppColors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 4),
                blurRadius: 6,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 128,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDefaults.radius),
                    topRight: Radius.circular(AppDefaults.radius),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: restaurant.imageUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.city!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    // Rating
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.rating.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
