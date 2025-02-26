import 'package:ard_resto_mobile_bnsp/business_logic/blocs/restaurants/restaurants_bloc.dart';
import 'package:ard_resto_mobile_bnsp/data/repositories/restaurants_repository.dart';
import 'package:ard_resto_mobile_bnsp/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'config/config.dart';
import 'data/constants/app_colors.dart';
import 'data/providers/api_provider.dart';

class App extends StatelessWidget {
  App({super.key});

  final _navigatorKey = GlobalKey<NavigatorState>();

  // repositories and providers
  final ApiProvider _apiProvider = ApiProvider();

  @override
  Widget build(BuildContext context) {
    // set status bar color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.secondary,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // remove the splash screen
    FlutterNativeSplash.remove();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          lazy: false,
          create: (context) => _apiProvider.init(),
        ),
        RepositoryProvider(
          create: (context) => RestaurantsRepository(
            apiProvider: _apiProvider,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<RestaurantsBloc>(
            lazy: false,
            create: (context) => RestaurantsBloc(
              restaurantsRepository: context.read<RestaurantsRepository>(),
            )
              ..add(RestaurantsFetchFavoriteData())
              ..add(RestaurantsFetchData()),
          ),
        ],
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: Config.appName,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        ),
      ),
    );
  }
}
