
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../storage/secure_storage_service.dart';
import 'endpoints.dart';

import '../../features/auth/services/auth_service.dart';
import '../navigation/navigation_service.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  static bool _isRedirectingToLogin = false;

  // Permet d'ignorer la redirection pendant certaines opérations.
  static const String skipAuthRedirectKey = 'skipAuthRedirect';

  static Future<void> initialize() async {
    dio.interceptors.clear();

    dio.interceptors.add(
      InterceptorsWrapper(
        // =========================================
        // REQUEST
        // =========================================

        onRequest: (options, handler) async {
          final token =
              await SecureStorageService.getAccessToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },

        // =========================================
        // ERROR
        // =========================================

        onError: (DioException e, handler) async {
          final statusCode = e.response?.statusCode;

          final skipRedirect =
              e.requestOptions.extra[skipAuthRedirectKey] == true;

          if (statusCode != 401 || skipRedirect) {
            return handler.next(e);
          }

          if (_isRedirectingToLogin) {
            return handler.next(e);
          }

          _isRedirectingToLogin = true;

          try {
            final context =
                NavigationService.navigatorKey.currentContext;

            if (context != null && context.mounted) {
              await AuthService.logout(context);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Votre session a expiré. Veuillez vous reconnecter.',
                    ),
                  ),
                );
              }
            } else {
              await SecureStorageService.clear();
            }
          } finally {
            _isRedirectingToLogin = false;
          }

          handler.next(e);
        },
      ),
    );
  }
}
