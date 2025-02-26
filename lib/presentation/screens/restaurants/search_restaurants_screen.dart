import 'dart:async';

import 'package:ard_resto_mobile_bnsp/business_logic/blocs/restaurants/restaurants_bloc.dart';
import 'package:ard_resto_mobile_bnsp/business_logic/utils/navigate_screen_utils.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_path_assets.dart';
import 'package:ard_resto_mobile_bnsp/data/models/restaurant.dart';
import 'package:ard_resto_mobile_bnsp/data/repositories/restaurants_repository.dart';
import 'package:ard_resto_mobile_bnsp/presentation/screens/restaurants/detail_restaurant_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_colors.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_defaults.dart';

class SearchRestaurantsScreen extends StatelessWidget {
  const SearchRestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RestaurantsBloc>(
      lazy: false,
      create: (context) => RestaurantsBloc(
        restaurantsRepository: context.read<RestaurantsRepository>(),
      )..add(RestaurantsFetchCity()),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              _SearchPageHeader(),
              SizedBox(height: 8),
              // _RecentSearchList(),
              _SearchResultRestaurants(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentSearchList extends StatelessWidget {
  const _RecentSearchList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Search',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 16),
              itemBuilder: (context, index) {
                return const SearchHistoryTile();
              },
              separatorBuilder: (context, index) => const Divider(
                thickness: 0.1,
              ),
              itemCount: 16,
            ),
          )
        ],
      ),
    );
  }
}

class _SearchPageHeader extends StatefulWidget {
  const _SearchPageHeader({super.key});

  @override
  State<_SearchPageHeader> createState() => _SearchPageHeaderState();
}

class _SearchPageHeaderState extends State<_SearchPageHeader> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(color: AppColors.primary),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                ),
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child:
                                BlocBuilder<RestaurantsBloc, RestaurantsState>(
                              builder: (context, state) {
                                return TextField(
                                  controller: _searchController,
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search restaurant",
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 0),
                                  ),
                                  onChanged: (value) {
                                    if (_debounce?.isActive ?? false) {
                                      _debounce?.cancel();
                                    }
                                    _debounce = Timer(
                                        const Duration(milliseconds: 500), () {
                                      context.read<RestaurantsBloc>().add(
                                          RestaurantsSearchAndFilter(
                                              keyword: value,
                                              city:
                                                  state.selectedFilterByCity));
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFD9D9D9),
                width: 1,
              ),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  BlocBuilder<RestaurantsBloc, RestaurantsState>(
                    builder: (context, state) {
                      return ListView.builder(
                        itemCount: state.cities.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: InkWell(
                              onTap: () {
                                context.read<RestaurantsBloc>().add(
                                    RestaurantsSearchAndFilter(keyword: _searchController.text,
                                        city: state.cities[index]));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  color: state.cities[index].name ==
                                          state.selectedFilterByCity!.name
                                      ? AppColors.primary
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Center(
                                    child: Text(
                                      state.cities[index].name!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: state.cities[index].name ==
                                                state.selectedFilterByCity!.name
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class SearchHistoryTile extends StatelessWidget {
  const SearchHistoryTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Row(
          children: [
            Text(
              'Vegetables',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            SvgPicture.asset("${AppPathAssets.icons}search_tile_arrow.svg}"),
          ],
        ),
      ),
    );
  }
}

class _SearchResultRestaurants extends StatefulWidget {
  const _SearchResultRestaurants({super.key});

  @override
  State<_SearchResultRestaurants> createState() =>
      _SearchResultRestaurantsState();
}

class _SearchResultRestaurantsState extends State<_SearchResultRestaurants> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    return Flexible(
      child: SizedBox(
        height: sizeScreen.height,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              BlocBuilder<RestaurantsBloc, RestaurantsState>(
                builder: (context, state) {
                  switch (state.status) {
                    case RestaurantsStatus.failure:
                      return const Center(child: Text('failed to fetch posts'));
                    case RestaurantsStatus.success:
                      if (state.searchedRestaurants.isEmpty) {
                        return const Center(child: Text('No result found!'));
                      }
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return (index >= state.searchedRestaurants.length)
                              ? state.searchedRestaurants.length > 10
                                  ? bottomLoaderWidget()
                                  : SizedBox()
                              : SearchResultRestaurantTile(
                                  restaurant: state.searchedRestaurants[index],
                                );
                        },
                        itemCount: state.hasReachedMax
                            ? state.searchedRestaurants.length
                            : state.searchedRestaurants.length + 1,
                      );
                    case RestaurantsStatus.initial || RestaurantsStatus.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                  }
                },
              ),
              // Add margin bottom
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<RestaurantsBloc>().add(RestaurantsFetchMoreDataResultSearchAndFilter());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Widget bottomLoaderWidget() {
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

class SearchResultRestaurantTile extends StatelessWidget {
  const SearchResultRestaurantTile({
    super.key,
    required this.restaurant,
  });

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        nextScreen(context, DetailRestaurantScreen(restaurant: restaurant));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 81,
                          height: 81,
                          decoration: BoxDecoration(
                            color: Color(0xffF0F0F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: restaurant.imageUrl!,
                              fit: BoxFit.fitHeight,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${restaurant.name}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "${restaurant.description}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 15,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${restaurant.rating}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 1,
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 15,
                            color: AppColors.black,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${restaurant.city}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 0,
              indent: 0,
              color: Color(0xffE1E0E0),
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}
