import 'package:ard_resto_mobile_bnsp/data/models/city.dart';
import 'package:ard_resto_mobile_bnsp/data/models/restaurant.dart';
import 'package:ard_resto_mobile_bnsp/data/models/response_api_model.dart';
import 'package:ard_resto_mobile_bnsp/data/repositories/restaurants_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:stream_transform/stream_transform.dart';

part 'restaurants_event.dart';

part 'restaurants_state.dart';

const throttleDuration = Duration(milliseconds: 200);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class RestaurantsBloc extends Bloc<RestaurantsEvent, RestaurantsState> {
  final RestaurantsRepository _restaurantsRepository;

  RestaurantsBloc({required RestaurantsRepository restaurantsRepository})
      : _restaurantsRepository = restaurantsRepository,
        super(RestaurantsInitial()) {
    on<RestaurantsFetchData>(
      _onRestaurantsFetchData,
      transformer: throttleDroppable(throttleDuration),
    );

    on<RestaurantsFetchFavoriteData>(
      _onRestaurantsFetchFavoriteData,
      transformer: throttleDroppable(throttleDuration),
    );
    on<RestaurantsFetchMoreDataResultSearchAndFilter>(
      _onRestaurantsFetchMoreDataResultSearch,
      transformer: throttleDroppable(throttleDuration),
    );
    on<RestaurantsFetchCity>(_onRestaurantsFetchCity);
    on<RestaurantsSearchAndFilter>(_onRestaurantsSearchAndFilter);
  }

  Future<void> _onRestaurantsFetchData(
      RestaurantsFetchData event, Emitter<RestaurantsState> emit) async {
    print("FETCH PRODUCT DATA FROM DB TRIGGERED: ${state.hasReachedMax}");

    if (state.hasReachedMax) return;
    try {
      var limit = 20;
      var page = (state.restaurants.length / limit).ceil() + 1;

      ResponseApiModel response = await _restaurantsRepository.getRestaurants(
        limit: limit,
        page: page,
      );
      // print("PRINT STATUS RESPONSE: ${response.data['restaurants']}");

      List<Restaurant> restaurants = (response.data['restaurants'] as List?)!
          .map((dynamic e) => Restaurant.fromJson(e as Map<String, dynamic>))
          .toList();

      if (response.status == StatusResponseApi.success) {
        emit(state.copyWith(
          status: RestaurantsStatus.success,
          restaurants: [...state.restaurants, ...restaurants],
          searchedRestaurants: [...state.searchedRestaurants, ...restaurants],
        ));

        print("TOTAL RESTAURANTS: ${state.restaurants.length}");
        print("TOTAL MAX DATA FROM API ${response.data['total']}");
        if (state.restaurants.length >= response.data['total']) {
          emit(state.copyWith(hasReachedMax: true));
        }
      } else {
        emit(
          state.copyWith(
            status: RestaurantsStatus.failure,
            errorMessage: response.message,
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: RestaurantsStatus.failure));
    }
  }


  Future<void> _onRestaurantsFetchFavoriteData(
      RestaurantsFetchFavoriteData event, Emitter<RestaurantsState> emit) async {
    print("FETCH FAVORITE DATA FROM DB TRIGGERED: ${state.hasReachedMax}");

    try {
      // Setup params to get favorite restaurants
      var limit = 10;
      var page = (state.restaurants.length / limit).ceil() + 1;
      var sortBy = 'rating';
      var sortOrder = 'desc';

      ResponseApiModel response = await _restaurantsRepository.getRestaurants(
        limit: limit,
        page: page,
        sortBy: sortBy,
        sortOrder: sortOrder
      );

      // print("PRINT STATUS RESPONSE: ${response.data['restaurants']}");
      List<Restaurant> favoriteRestaurants = (response.data['restaurants'] as List?)!
          .map((dynamic e) => Restaurant.fromJson(e as Map<String, dynamic>))
          .toList();

      if (response.status == StatusResponseApi.success) {
        emit(state.copyWith(
          status: RestaurantsStatus.success,
          favoriteRestaurants: favoriteRestaurants,
        ));
      } else {
        emit(
          state.copyWith(
            status: RestaurantsStatus.failure,
            errorMessage: response.message,
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: RestaurantsStatus.failure));
    }
  }

  Future<void> _onRestaurantsFetchMoreDataResultSearch(
      RestaurantsFetchMoreDataResultSearchAndFilter event, Emitter<RestaurantsState> emit) async {
    print("FETCH PRODUCT DATA FROM DB TRIGGERED: ${state.hasReachedMax}");

    print("PRINT SEARCH KEYWORD: ${state.searchKeyword}");
    print("PRINT SELECTED FILTER BY CITY: ${state.selectedFilterByCity}");


    if (state.hasReachedMax) return;
    try {
      var limit = 10;
      var page = (state.searchedRestaurants.length / limit).ceil() + 1;
      var city = state.selectedFilterByCity.name == "Semua" ? '' : state.selectedFilterByCity.name;

      print("PRINT LIMIT: ${limit}");
      print("PRINT PAGE: ${page}");

      ResponseApiModel response = await _restaurantsRepository.getRestaurants(
        limit: limit,
        page: page,
        search: state.searchKeyword,
        city: city,
      );

      print("PRINT STATUS RESPONSE: ${response.data['restaurants']}");

      List<Restaurant> restaurants = (response.data['restaurants'] as List?)!
          .map((dynamic e) => Restaurant.fromJson(e as Map<String, dynamic>))
          .toList();

      print("PRINT Restaurant DATA: ${restaurants}");

      print("PRINT TOTAL DATA RESTAURANT: ${state.restaurants.length}");

      if (response.status == StatusResponseApi.success) {
        emit(state.copyWith(
          status: RestaurantsStatus.success,
          searchedRestaurants: [...state.searchedRestaurants, ...restaurants],
        ));

        print("TOTAL RESTAURANTS: ${state.restaurants.length}");
        print("TOTAL MAX DATA FROM API ${response.data['total']}");
        if (state.searchedRestaurants.length >= response.data['total']) {
          emit(state.copyWith(hasReachedMax: true));
        }
      } else {
        emit(
          state.copyWith(
            status: RestaurantsStatus.failure,
            errorMessage: response.message,
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: RestaurantsStatus.failure));
    }
  }

  Future<void> _onRestaurantsFetchCity(
      RestaurantsFetchCity event, Emitter<RestaurantsState> emit) async {
    try {
      ResponseApiModel response = await _restaurantsRepository.getCities();
      print("PRINT STATUS RESPONSE: ${response.data}");

      final cities = <City>[];
      cities.add(City(id: 0, name: "Semua"));
      for (var i = 0; i < response.data.length; i++) {
        cities.add(City(id: i + 1, name: response.data[i]));
      }

      emit(state.copyWith(
        status: RestaurantsStatus.success,
        cities: cities,
        selectedFilterByCity: cities[0],
      ));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: RestaurantsStatus.failure));
    }
  }

  Future<void> _onRestaurantsSearchAndFilter(
      RestaurantsSearchAndFilter event, Emitter<RestaurantsState> emit) async {
    debugPrint("RESTAURANT SEARCH TRIGGERED");
    debugPrint("RESTAURANT SEARCH: ${event.keyword}");

    try {
      var limit = 10;
      var page = (state.restaurants.length / limit).ceil() + 1;
      var city = event.city.name == "Semua" ? '' : event.city.name;

      ResponseApiModel response = await _restaurantsRepository.getRestaurants(
        limit: limit,
        page: page,
        search: event.keyword,
        city: city,
      );

      List<Restaurant> resultSearchRestaurants = (response.data['restaurants']
              as List?)!
          .map((dynamic e) => Restaurant.fromJson(e as Map<String, dynamic>))
          .toList();

      if (state.searchedRestaurants.isNotEmpty) {
        state.searchedRestaurants.clear();
      }
      emit(state.copyWith(
        status: RestaurantsStatus.success,
        searchedRestaurants: [...resultSearchRestaurants],
        searchKeyword: event.keyword,
        selectedFilterByCity: event.city,
        hasReachedMax: false,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(status: RestaurantsStatus.failure));
    }
  }
}
