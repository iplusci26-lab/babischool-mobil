
class SchoolAccessModel {
  final String schoolId;
  final String schoolName;
  final String schoolCode;
  final String roleId;
  final String roleName;
  final String roleCode;

  const SchoolAccessModel({
    required this.schoolId,
    required this.schoolName,
    this.schoolCode = '',
    required this.roleId,
    required this.roleName,
    required this.roleCode,
  });

  factory SchoolAccessModel.fromJson(Map<String, dynamic> json) {
    return SchoolAccessModel(
      schoolId: (json["school_id"] ?? "").toString(),
      schoolName: (json["school_name"] ?? "École").toString(),
      schoolCode: (json["school_code"] ?? "").toString(),
      roleId: (json["role_id"] ?? "").toString(),
      roleName: (json["role_name"] ?? json["role_code"] ?? "Utilisateur").toString(),
      roleCode: (json["role_code"] ?? "").toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "school_id": schoolId,
      "school_name": schoolName,
      "school_code": schoolCode,
      "role_id": roleId,
      "role_name": roleName,
      "role_code": roleCode,
    };
  }
}
