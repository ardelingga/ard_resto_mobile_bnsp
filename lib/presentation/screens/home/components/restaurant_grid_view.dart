import 'package:ard_resto_mobile_bnsp/business_logic/blocs/restaurants/restaurants_bloc.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_colors.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_defaults.dart';
import 'package:ard_resto_mobile_bnsp/presentation/components/title_section_component.dart';
import 'package:ard_resto_mobile_bnsp/presentation/screens/restaurants/components/item_restaurant_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestaurantGridView extends StatelessWidget {
  const RestaurantGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleSectionComponent(
          title: 'Daftar Restoran',
          onTap: () {
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding,
          ),
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
                  return GridView.builder(
                    padding: const EdgeInsets.only(top: AppDefaults.padding),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Jumlah kolom
                      childAspectRatio: 0.78, // Rasio antara tinggi dan lebar item
                      crossAxisSpacing: 16, // Jarak horizontal antar item
                      mainAxisSpacing: 16, // Jarak vertikal antar item
                    ),
                    itemCount: state.restaurants.length,
                    itemBuilder: (context, index) {
                      return ItemRestaurantGridView(restaurant: state.restaurants[index]);
                    },
                  );
                default:
                  return SizedBox();
              }
            },
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        BlocBuilder<RestaurantsBloc, RestaurantsState>(
          builder: (context, state) {
            return !state.hasReachedMax
                ? Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        color: AppColors.secondary,
                      ),
                    ),
                  )
                : SizedBox();
          },
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget BottomLoader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Center(
        child: SizedBox(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
