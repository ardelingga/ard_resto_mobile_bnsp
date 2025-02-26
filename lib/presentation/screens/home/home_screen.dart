import 'package:ard_resto_mobile_bnsp/business_logic/blocs/restaurants/restaurants_bloc.dart';
import 'package:ard_resto_mobile_bnsp/business_logic/utils/navigate_screen_utils.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_colors.dart';
import 'package:ard_resto_mobile_bnsp/data/constants/app_path_assets.dart';
import 'package:ard_resto_mobile_bnsp/presentation/screens/home/components/banner_slider_component.dart';
import 'package:ard_resto_mobile_bnsp/presentation/screens/home/components/restaurant_grid_view.dart';
import 'package:ard_resto_mobile_bnsp/presentation/screens/restaurants/search_restaurants_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/favorite_restaurants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  late Size sizeScreen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.secondary,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              color: AppColors.white,
            ),
          ),
        ),
        title: Row(
          children: [
            Image.asset(
              "${AppPathAssets.images}logo_ard_resto_bnsp_white.png",
              height: 40,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(context, SearchRestaurantsScreen());
            },
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: SizedBox(
        width: sizeScreen.width,
        height: sizeScreen.height,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              const SizedBox(height: 15),
              BannerSliderComponent(),
              const SizedBox(height: 20),
              FavoriteRestaurants(),
              const SizedBox(height: 20),
              RestaurantGridView(),
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
    if (_isBottom) context.read<RestaurantsBloc>().add(RestaurantsFetchData());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
