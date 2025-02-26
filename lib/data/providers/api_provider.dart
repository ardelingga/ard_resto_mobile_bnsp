import 'package:ard_resto_mobile_bnsp/business_logic/utils/dio_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../config/config.dart';

class ApiProvider {
  Dio? dio;
  CancelToken cancelToken = CancelToken();

  Future<void> init() async {
    var options = BaseOptions(
        baseUrl: Config.baseUrlDev,
        contentType: Headers.formUrlEncodedContentType,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60));

    dio = Dio(options);

    // Setup penyimpanan cache agar tetap ada meskipun aplikasi ditutup
    final dir = await getApplicationDocumentsDirectory();
    final cacheStore = HiveCacheStore(dir.path);

    // Setup dio cache interceptor
    dio!.interceptors.add(DioCacheInterceptor(
      options: CacheOptions(
        store: cacheStore, // Menggunakan HiveCacheStore agar cache persist
        policy: CachePolicy.refreshForceCache, // Gunakan cache tapi tetap di-refresh jika expired
        hitCacheOnErrorExcept: [401, 403], // Jika server error (401, 403), tetap gunakan cache
        maxStale: const Duration(minutes: 10), // Cache akan expired setelah 10 menit
        keyBuilder: (request) => request.uri.toString(), // Cache berdasarkan URL+query
      ),
    ));

    // Tambahkan interceptor custom & logger
    dio!.interceptors.add(DioInterceptors());
    dio!.interceptors.add(PrettyDioLogger());
  }

  Future<void> close() async {
    cancelToken.cancel();
    dio?.close();
  }

  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      print("🔍 GET Request to: $url");
      print("📦 Query Parameters: $queryParameters");

      final response = await dio!.get(
        url,
        queryParameters: queryParameters,
        options: options ?? Options(),
        cancelToken: cancelToken,
      );

      print("✅ Response Received: ${response.data}");
      return response;
    } on DioException catch (e) {
      print("❌ DioError: ${e.type} - ${e.message}");
      throw e;
    } catch (e) {
      print("⚠️ Unknown Error: $e");
      rethrow;
    }
  }

  Future<Response> post(String url,
      {Map<String, dynamic>? data, Options? options}) async {
    return await dio!.post(
      url,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response> put(
      String url, {
        Map<String, dynamic>? data,
        Options? options,
      }) async {
    return await dio!.put(
      url,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response> delete(
      String url, {
        Map<String, dynamic>? data,
        Options? options,
      }) async {
    return await dio!.delete(
      url,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
