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
}