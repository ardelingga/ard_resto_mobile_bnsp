part of 'restaurants_bloc.dart';

enum RestaurantsStatus { initial, loading, success, failure }

final class RestaurantsState extends Equatable {
  const RestaurantsState({
    this.status = RestaurantsStatus.initial,
    this.errorMessage = '',
    this.successMessage = '',
    this.restaurants = const <Restaurant>[],
    this.favoriteRestaurants = const <Restaurant>[],
    this.searchedRestaurants = const <Restaurant>[],
    this.searchKeyword = '',
    this.cities = const <City>[],
    this.selectedFilterByCity = const City.empty(),
    this.hasReachedMax = false,
  });

  final RestaurantsStatus status;
  final String errorMessage;
  final String successMessage;
  final List<Restaurant> restaurants;
  final List<Restaurant> favoriteRestaurants;
  final List<Restaurant> searchedRestaurants;
  final String searchKeyword;
  final List<City> cities;
  final City selectedFilterByCity;
  final bool hasReachedMax;

  RestaurantsState copyWith({
    RestaurantsStatus? status,
    String? errorMessage,
    String? successMessage,
    List<Restaurant>? restaurants,
    List<Restaurant>? favoriteRestaurants,
    List<Restaurant>? searchedRestaurants,
    String? searchKeyword,
    List<City>? cities,
    City? selectedFilterByCity,
    bool? hasReachedMax,
  }) {
    return RestaurantsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      favoriteRestaurants: favoriteRestaurants ?? this.favoriteRestaurants,
      restaurants: restaurants ?? this.restaurants,
      searchedRestaurants: searchedRestaurants ?? this.searchedRestaurants,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      cities: cities ?? this.cities,
      selectedFilterByCity:
          selectedFilterByCity ?? this.selectedFilterByCity,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  // to string
  @override
  String toString() =>
      'RestaurantsState(status: $status, hasReachedMax: $hasReachedMax), restaurants: ${restaurants.length}';

  @override
  List<Object> get props => [
        status,
        errorMessage,
        successMessage,
        restaurants,
        favoriteRestaurants,
        searchedRestaurants,
        searchKeyword,
        cities,
        selectedFilterByCity,
        hasReachedMax,
      ];
}

final class RestaurantsInitial extends RestaurantsState {}


