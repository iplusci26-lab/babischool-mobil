
class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String phone;
  final String userType;

  final String? parentId;
  final String? teacherId;
  final String? staffId;
  final String? activeChild;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.userType,
    this.parentId,
    this.teacherId,
    this.staffId,
    this.activeChild,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json["id"] ?? "").toString(),
      firstName: (json["first_name"] ?? "").toString(),
      lastName: (json["last_name"] ?? "").toString(),
      phone: (json["phone"] ?? "").toString(),
      userType: (json["user_type"] ?? "").toString(),
      parentId: json["parent_id"]?.toString(),
      teacherId: json["teacher_id"]?.toString(),
      staffId: json["staff_id"]?.toString(),
      activeChild: json["active_child"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "user_type": userType,
      "parent_id": parentId,
      "teacher_id": teacherId,
      "staff_id": staffId,
      "active_child": activeChild,
    };
  }
}
