import 'package:dio/dio.dart';

import '../storage/secure_storage_service.dart';

import 'endpoints.dart';

import 'package:flutter/material.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/services/auth_service.dart';
import '../navigation/navigation_service.dart';

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
  // Empêche plusieurs redirections simultanées
  static bool _isRedirectingToLogin = false;
  static Future<void> initialize() async {

      dio.interceptors.clear();

      dio.interceptors.add(

        InterceptorsWrapper(

          //------------------------------------------------------
          // REQUEST
          //------------------------------------------------------

          onRequest: (

            options,
            handler,

          ) async {

            final token =
                await SecureStorageService.getAccessToken();

            if (token != null) {

              options.headers["Authorization"] =
                  "Bearer $token";

            }

            handler.next(options);

          },

          //------------------------------------------------------
          // ERROR
          //------------------------------------------------------

          onError: (

          DioException e,
          ErrorInterceptorHandler handler,

        ) async {

            if (e.response?.statusCode == 401) {

              //--------------------------------------------------
              // Une redirection est déjà en cours
              //--------------------------------------------------

              if (_isRedirectingToLogin) {

                return handler.next(e);

              }

              _isRedirectingToLogin = true;


              

              //--------------------------------------------------
              // Nettoyage de la session
              //--------------------------------------------------

                final context = NavigationService.navigatorKey.currentContext;

                  if (context != null) {

                      await AuthService.logout(
                        context,
                       );

                  }
                                  
                // Petite pause pour laisser le temps à la navigation
                await Future.delayed(
                  const Duration(milliseconds: 500),
                );

                _isRedirectingToLogin = false;

                //--------------------------------------------------
                // Afficher un message
                //--------------------------------------------------

               

                if (context != null) {

                  ScaffoldMessenger.of(context).showSnackBar(

                    const SnackBar(

                      content: Text(

                        "Votre session a expiré. Veuillez vous reconnecter.",

                      ),

                    ),

                  );

                }
                

              }

              handler.next(e);

      },

    ),

  );

}
}