import 'package:flutter/material.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../login_screen.dart';
import '../../../core/api/api_client.dart';
import '../models/login_response_model.dart';
import '../../../core/api/endpoints.dart';
import '../models/school_access_model.dart';


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

  Future<LoginResponseModel> selectContext({
  required String phone,
  required String password,
  required SchoolAccessModel access,
}) async {
  final response = await ApiClient.dio.post(
    Endpoints.selectContext,
    data: {
      "phone": phone,
      "password": password,
      "school_id": access.schoolId,
      "role_id": access.roleId,
    },
  );

  return LoginResponseModel.fromJson(
    Map<String, dynamic>.from(response.data),
  );
}


Future<LoginResponseModel> switchContext({
  required SchoolAccessModel access,
}) async {
  final response = await ApiClient.dio.post(
    Endpoints.switchContext,
    data: {
      "school_id": access.schoolId,
      "role_id": access.roleId,
    },
  );

  return LoginResponseModel.fromJson(
    Map<String, dynamic>.from(response.data),
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