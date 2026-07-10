import 'user_model.dart';

class LoginResponseModel {

  final String access;

  final String refresh;

  final UserModel user;

  const LoginResponseModel({

    required this.access,

    required this.refresh,

    required this.user,

  });

  factory LoginResponseModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return LoginResponseModel(

      access: json["access"],

      refresh: json["refresh"],

      user: UserModel.fromJson(

        json["user"],

      ),

    );

  }

}