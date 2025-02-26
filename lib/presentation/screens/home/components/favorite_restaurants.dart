import 'package:ard_resto_mobile_bnsp/business_logic/blocs/restaurants/restaurants_bloc.dart';
import 'package:ard_resto_mobile_bnsp/presentation/components/title_section_component.dart';
import 'package:ard_resto_mobile_bnsp/presentation/screens/restaurants/components/item_restaurant_listview_view.dart';
import 'package:flutter/material.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_defaults.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteRestaurants extends StatelessWidget {
  const FavoriteRestaurants({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleSectionComponent(
          title: 'Restoran Favorit',
          onTap: () {
          },
        ),
        const SizedBox(height: AppDefaults.padding),
        SingleChildScrollView(
          padding: const EdgeInsets.only(left: AppDefaults.padding),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                height: 250,
                child: BlocBuilder<RestaurantsBloc, RestaurantsState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case RestaurantsStatus.failure:
                        return const Center(
                            child: Text('Failed to fetch data from server'));
                      case RestaurantsStatus.success:
                        if (state.restaurants.isEmpty) {
                          return const Center(child: Text('No restaurants'));
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.favoriteRestaurants.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(right: 16, bottom: 8),
                              child: ItemRestaurantListView(restaurant: state.restaurants[index]),
                            )
                        );
                      default:
                        return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
