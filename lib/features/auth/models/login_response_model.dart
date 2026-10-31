
import 'user_model.dart';
import 'school_access_model.dart';

class LoginResponseModel {
  final String? access;
  final String? refresh;
  final UserModel? user;
  final bool requiresContext;
  final List<SchoolAccessModel> accesses;
  final Map<String, dynamic>? context;

  const LoginResponseModel({
    this.access,
    this.refresh,
    this.user,
    this.requiresContext = false,
    this.accesses = const [],
    this.context,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final rawAccesses = json["accesses"] as List? ?? [];

    return LoginResponseModel(
      access: json["access"]?.toString(),
      refresh: json["refresh"]?.toString(),

      user: json["user"] is Map
          ? UserModel.fromJson(
              Map<String, dynamic>.from(json["user"]),
            )
          : null,

      requiresContext: json["requires_context"] == true,

      accesses: rawAccesses
          .whereType<Map>()
          .map(
            (item) => SchoolAccessModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),

      context: json["context"] is Map
          ? Map<String, dynamic>.from(json["context"])
          : null,
    );
  }
}
