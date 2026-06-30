import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {

  static const FlutterSecureStorage
      storage =
      FlutterSecureStorage();

  static Future<void> saveAccessToken(
    String token,
  ) async {

    await storage.write(
      key: "access",
      value: token,
    );
  }

  static Future<void> saveRefreshToken(
    String token,
  ) async {

    await storage.write(
      key: "refresh",
      value: token,
    );
  }

  static Future<String?> getAccessToken()
  async {

    return await storage.read(
      key: "access",
    );
  }

  static Future<String?> getRefreshToken()
  async {

    return await storage.read(
      key: "refresh",
    );
  }

  static Future<void> clear()
  async {

    await storage.deleteAll();
  }

  
}