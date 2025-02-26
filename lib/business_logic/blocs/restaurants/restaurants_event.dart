part of 'restaurants_bloc.dart';


sealed class RestaurantsEvent extends Equatable {
  const RestaurantsEvent();

  @override
  List<Object> get props => [];
}

final class RestaurantsFetchData extends RestaurantsEvent {}

final class RestaurantsFetchFavoriteData extends RestaurantsEvent {}

final class RestaurantsFetchMoreDataResultSearchAndFilter extends RestaurantsEvent {}

final class RestaurantsFetchCity extends RestaurantsEvent {}

final class RestaurantsSearchAndFilter extends RestaurantsEvent {
  final String keyword;
  final City city;
  const RestaurantsSearchAndFilter({required this.keyword, required this.city});
}

