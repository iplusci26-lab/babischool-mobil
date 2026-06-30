import '../../core/api/api_client.dart';

import '../../core/api/endpoints.dart';

class AuthService {

  Future<Map<String,dynamic>>
  login({

    required String phone,

    required String password,

  }) async {

    final response =
    await ApiClient.dio.post(

      Endpoints.login,

      data: {

        "phone": phone,

        "password": password,
      },
    );

    return response.data;
  }
}