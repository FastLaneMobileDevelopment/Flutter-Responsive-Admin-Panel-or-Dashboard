import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'http_interceptors/auth_interceptor.dart';


class HttpClient {

  final Dio _dio = Dio();

  HttpClient() {
    _dio.interceptors..add(AuthInterceptor())..add(
          DioCacheManager(cacheConfig).interceptor);

    _dio.options.headers.putIfAbsent("Access-Control-Allow-Origin", () => "*");
    _dio.options.headers.putIfAbsent("Access-Control-Allow-Headers", () => "Access-Control-Allow-Origin, Accept");

    //if () {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
      );
    //}
  }

  final CacheConfig cacheConfig = CacheConfig();


  Dio get dio {

    return _dio;
  }

}
