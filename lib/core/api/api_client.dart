import 'package:dio/dio.dart';

import '../storage/secure_storage_service.dart';

import 'endpoints.dart';

class ApiClient {

  static final Dio dio = Dio(

    BaseOptions(

      baseUrl:
      Endpoints.baseUrl,

      connectTimeout:
      const Duration(seconds: 30),

      receiveTimeout:
      const Duration(seconds: 30),
    ),
  );

  static Future<void> initialize()
  async {

    dio.interceptors.add(

      InterceptorsWrapper(

        onRequest:
        (
          options,
          handler,
        ) async {

          final token =
          await SecureStorageService
          .getAccessToken();
          if (token != null) {
            
            options.headers[
              "Authorization"
            ] =
            "Bearer $token";
          }

          return handler.next(
            options,
          );
        },
      ),
    );
  }
}