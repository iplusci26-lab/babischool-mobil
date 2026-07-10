class TeacherStudentModel {

  final String id;

  final String enrollmentId;

  final String name;

  final String registration;

  final String gender;

  final String? avatar;

  final String? attendance;

  const TeacherStudentModel({

    required this.id,

    required this.enrollmentId,

    required this.name,

    required this.registration,

    required this.gender,

    required this.avatar,

    required this.attendance,

  });

  factory TeacherStudentModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return TeacherStudentModel(

      id: json["id"],

      enrollmentId: json["enrollment_id"],

      name: json["name"],

      registration: json["registration"],

      gender: json["gender"] ?? "",

      avatar: json["avatar"],

      attendance: json["attendance"],

    );

  }

}