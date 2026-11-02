
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  // ==========================
  // KEYS
  // ==========================

  static const String _accessTokenKey = "access_token";
  static const String _refreshTokenKey = "refresh_token";
  static const String _userKey = "user";
  static const String _userTypeKey = "user_type";
  static const String _availableAccessesKey = "available_accesses";
  static const String _schoolIdKey = "active_school_id";
  static const String _schoolNameKey = "active_school_name";
  static const String _roleIdKey = "active_role_id";
  static const String _roleNameKey = "active_role_name";
  static const String _roleCodeKey = "active_role_code";

  // ==========================
  // ACCESS TOKEN
  // ==========================

  static Future<void> saveAccessToken(String token) async {
    await _storage.write(
      key: _accessTokenKey,
      value: token,
    );
  }

  static Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  // ==========================
  // REFRESH TOKEN
  // ==========================

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(
      key: _refreshTokenKey,
      value: token,
    );
  }

  static Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  // ==========================
  // USER TYPE / ROLE
  // ==========================

  static Future<void> saveUserType(String userType) async {
    await _storage.write(
      key: _userTypeKey,
      value: userType,
    );
  }

  static Future<String?> getUserType() async {
    return _storage.read(key: _userTypeKey);
  }

  // ==========================
  // USER
  // ==========================

  static Future<void> saveUser(
    Map<String, dynamic> user,
  ) async {
    await _storage.write(
      key: _userKey,
      value: jsonEncode(user),
    );
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final json = await _storage.read(key: _userKey);

    if (json == null || json.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(json);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return null;
  }

  static Future<void> saveAvailableAccesses(
  List<Map<String, dynamic>> accesses,
) async {
  await _storage.write(
    key: _availableAccessesKey,
    value: jsonEncode(accesses),
  );
}

static Future<List<Map<String, dynamic>>> getAvailableAccesses() async {
  final json = await _storage.read(
    key: _availableAccessesKey,
  );

  if (json == null || json.isEmpty) {
    return [];
  }

  final decoded = jsonDecode(json);

  if (decoded is! List) {
    return [];
  }

  return decoded
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

  // ==========================
  // ACTIVE SCHOOL
  // ==========================

  static Future<void> saveActiveSchool({
    required String schoolId,
    required String schoolName,
  }) async {
    await _storage.write(
      key: _schoolIdKey,
      value: schoolId,
    );

    await _storage.write(
      key: _schoolNameKey,
      value: schoolName,
    );
  }

  static Future<String?> getActiveSchoolId() async {
    return _storage.read(key: _schoolIdKey);
  }

  static Future<String?> getActiveSchoolName() async {
    return _storage.read(key: _schoolNameKey);
  }

  // ==========================
  // ACTIVE ROLE
  // ==========================

  static Future<void> saveActiveRole({
    required String roleId,
    required String roleName,
    required String roleCode,
  }) async {
    await _storage.write(
      key: _roleIdKey,
      value: roleId,
    );

    await _storage.write(
      key: _roleNameKey,
      value: roleName,
    );

    await _storage.write(
      key: _roleCodeKey,
      value: roleCode,
    );

    // Synchronise le rôle utilisé par SplashScreen.
    await saveUserType(roleCode);
  }

  static Future<String?> getActiveRoleId() async {
    return _storage.read(key: _roleIdKey);
  }

  static Future<String?> getActiveRoleName() async {
    return _storage.read(key: _roleNameKey);
  }

  static Future<String?> getActiveRoleCode() async {
    return _storage.read(key: _roleCodeKey);
  }

  // ==========================
  // SAVE COMPLETE SESSION
  // ==========================

  
  static Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> user,
    required String schoolId,
    required String schoolName,
    required String roleId,
    required String roleName,
    required String roleCode,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
    await saveUser(user);

    await saveActiveSchool(
      schoolId: schoolId,
      schoolName: schoolName,
    );

    await saveActiveRole(
      roleId: roleId,
      roleName: roleName,
      roleCode: roleCode,
    );
  }

  // ==========================
  // SESSION
  // ==========================

  static Future<bool> hasSession() async {
    final token = await getAccessToken();

    return token != null && token.isNotEmpty;
  }

  // ==========================
  // LOGOUT
  // ==========================

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
