import 'package:dio/dio.dart';

class DioInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("🚀 Request: ${options.uri}");
    handler.next(options); // Pastikan ini hanya dipanggil sekali
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.headers.map['x-cache']?.contains('HIT') == true) {
      print("✅ Cache Used: ${response.requestOptions.uri}");
    } else {
      print("🌐 Data Fetched from API: ${response.requestOptions.uri}");
    }
    handler.next(response); // Pastikan ini hanya dipanggil sekali
  }

  @override
  void onError(DioException e, ErrorInterceptorHandler handler) {
    print("❌ Error: ${e.message}");
    handler.next(e); // Pastikan ini hanya dipanggil sekali
  }
}
