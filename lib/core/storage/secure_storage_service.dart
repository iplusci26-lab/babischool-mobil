import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {

  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  //==========================
  // KEYS
  //==========================

  static const String _accessTokenKey =
      "access_token";

  static const String _refreshTokenKey =
      "refresh_token";

  static const String _userKey =
      "user";

  static const String _userTypeKey =
      "user_type";

  //==========================
  // ACCESS TOKEN
  //==========================

  static Future<void> saveAccessToken(
    String token,
  ) async {

    await _storage.write(

      key: _accessTokenKey,

      value: token,

    );

  }

  static Future<String?> getAccessToken()
  async {

    return await _storage.read(

      key: _accessTokenKey,

    );

  }

  //==========================
  // REFRESH TOKEN
  //==========================

  static Future<void> saveRefreshToken(
    String token,
  ) async {

    await _storage.write(

      key: _refreshTokenKey,

      value: token,

    );

  }

  static Future<String?> getRefreshToken()
  async {

    return await _storage.read(

      key: _refreshTokenKey,

    );

  }

  //==========================
  // USER TYPE
  //==========================

  static Future<void> saveUserType(
    String userType,
  ) async {

    await _storage.write(

      key: _userTypeKey,

      value: userType,

    );

  }

  static Future<String?> getUserType()
  async {

    return await _storage.read(

      key: _userTypeKey,

    );

  }

  //==========================
  // USER
  //==========================

  static Future<void> saveUser(
    Map<String, dynamic> user,
  ) async {

    await _storage.write(

      key: _userKey,

      value: jsonEncode(user),

    );

  }

  static Future<Map<String, dynamic>?> getUser()
  async {

    final json = await _storage.read(

      key: _userKey,

    );

    if (json == null) {

      return null;

    }

    return jsonDecode(json);

  }

  //==========================
  // SESSION
  //==========================

  static Future<bool> hasSession()
  async {

    final token =
        await getAccessToken();

    return token != null &&
        token.isNotEmpty;

  }

  //==========================
  // LOGOUT
  //==========================

  static Future<void> clear()
  async {

    await _storage.deleteAll();

  }

}