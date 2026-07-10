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

  factory UserModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return UserModel(

      id: json["id"],

      firstName: json["first_name"],

      lastName: json["last_name"],

      phone: json["phone"],

      userType: json["user_type"],

      parentId: json["parent_id"],

      teacherId: json["teacher_id"],

      staffId: json["staff_id"],

      activeChild: json["active_child"],

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