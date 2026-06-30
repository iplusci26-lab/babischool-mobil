import 'dart:io';
import 'package:dio/dio.dart';

import '../../../core/api/api_client.dart';

import '../models/profile_model.dart';

class ProfileService {

  Future<ProfileModel> getProfile()
  async {

    final Response response =
        await ApiClient.dio.get(
      "/auth/profile/",
    );

    return ProfileModel.fromJson(
      response.data,
    );
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {

    await ApiClient.dio.put(
      "/auth/profile/",
      data: {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
      },
    );
  }

Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
}) async {

  await ApiClient.dio.post(
    "/auth/change-password/",
    data: {
      "current_password":
          currentPassword,
      "new_password":
          newPassword,
    },
  );
}

Future<void> uploadAvatar(
  File image,
) async {

  final fileName =
      image.path.split("/").last;

  final formData = FormData.fromMap({

    "avatar": await MultipartFile.fromFile(
      image.path,
      filename: fileName,
    ),
  });

  await ApiClient.dio.put(
    "/auth/profile/",
    data: formData,
  );
}

}