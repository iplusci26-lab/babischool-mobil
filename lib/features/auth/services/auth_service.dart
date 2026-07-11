import 'package:flutter/material.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../login_screen.dart';
import '../../../core/api/api_client.dart';
import '../models/login_response_model.dart';
import '../../../core/api/endpoints.dart';

class AuthService {

  Future<LoginResponseModel>login({

    required String phone,

    required String password,

  }) async {

    final response = await ApiClient.dio.post(

      Endpoints.login,

      data: {

        "phone": phone,

        "password": password,
      },
    );

    return LoginResponseModel.fromJson( 
      response.data,
    );
  }

  //------------------------------------------------------
  // LOGOUT
  //------------------------------------------------------

  static Future<void> logout(
    BuildContext context,
  ) async {

    //--------------------------------------------------
    // Supprimer toute la session
    //--------------------------------------------------

    await SecureStorageService.clear();

    if (!context.mounted) return;

    //--------------------------------------------------
    // Retour Login
    //--------------------------------------------------

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(

        builder: (_) => const LoginScreen(),

      ),

      (_) => false,

    );

  }

}