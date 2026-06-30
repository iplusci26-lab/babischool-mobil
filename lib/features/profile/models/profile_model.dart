class ProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String userType;
  final String? role;
  final String? avatar;
  final String? schoolName;
  final String? schoolSigle;
  final bool isActive;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.userType,
    this.role,
    this.avatar,
    this.schoolName,
    this.schoolSigle,
    required this.isActive,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProfileModel(
      id: json["id"],
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      userType: json["user_type"] ?? "",
      role: json["role"],
      avatar: json["avatar"],
      schoolName: json["school_name"],
      schoolSigle: json["school_sigle"],
      isActive: json["is_active"] ?? false,
    );
  }

  String get fullName =>
      "$firstName $lastName";
}