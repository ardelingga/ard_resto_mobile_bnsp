import 'package:ard_resto_mobile_bnsp/data/models/response_api_model.dart';
import 'package:ard_resto_mobile_bnsp/data/providers/api_provider.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';

class RestaurantsRepository {
  final ApiProvider _apiProvider;

  RestaurantsRepository({
    required ApiProvider apiProvider,

  })  : _apiProvider = apiProvider;

  Future<ResponseApiModel> getRestaurants({
    search = '',
    sortBy = 'created_at',
    sortOrder = 'desc',
    page = 1,
    limit = 10,
    city = '' // filter by city
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final cacheStore = HiveCacheStore(dir.path);



      final response = await _apiProvider.get(
        '/restaurants',
        options: CacheOptions(policy: CachePolicy.request, store: cacheStore).toOptions().copyWith(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        queryParameters: {
          'search': search,
          'sortBy': sortBy,
          'sortOrder': sortOrder,
          'page': page,
          'limit': limit,
          'city': city,
        },
      );

      print("PRINT RESPONS DIO RESTAURANT DATA: ${response.data['data']}");
      print("PRINT STATUS CODE RESTAURANT: ${response.statusCode}");

      if (response.statusCode == 304) {
        print("✅ Menggunakan data dari cache karena API tidak berubah.");
        return ResponseApiModel(
          status: StatusResponseApi.success,
          message: "Data dari cache",
          data: response.data['data'] ?? [],
        );
      }

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ResponseApiModel(
            status: StatusResponseApi.success,
            message: response.data['message'],
            data: response.data['data']);
      } else {
        return ResponseApiModel(
            status: StatusResponseApi.failure,
            message: response.data['message'],
            data: response.data['data']);
      }
    } on DioException catch (e) {
      return ResponseApiModel(
        status: StatusResponseApi.failure,
        message: e.response?.data?['message'] ?? "Error from server",
        data: e.response!.data['data'],
      );
    }
  }
  Future<ResponseApiModel> getCities() async {
    final dir = await getApplicationDocumentsDirectory();
    final cacheStore = HiveCacheStore(dir.path);

    try {
      final response = await _apiProvider.get(
        '/restaurants/cities',
        options: CacheOptions(policy: CachePolicy.request, store: cacheStore).toOptions().copyWith(
          headers: {
            'Content-Type': 'application/json',
          },
        )
      );

      print("PRINT RESPONS DIO RESTAURANT DATA: ${response.data['data']}");
      print("PRINT STATUS CODE RESTAURANT: ${response.statusCode}");

      if (response.statusCode == 304) {
        print("✅ Menggunakan data dari cache karena API tidak berubah.");
        return ResponseApiModel(
          status: StatusResponseApi.success,
          message: "Data dari cache",
          data: response.data['data'] ?? [],
        );
      }

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return ResponseApiModel(
            status: StatusResponseApi.success,
            message: response.data['message'],
            data: response.data['data']);
      } else {
        return ResponseApiModel(
            status: StatusResponseApi.failure,
            message: response.data['message'],
            data: response.data['data']);
      }
    } on DioException catch (e) {
      return ResponseApiModel(
        status: StatusResponseApi.failure,
        message: e.response!.data['message'],
        data: e.response!.data['data'],
      );
    }
  }
}
