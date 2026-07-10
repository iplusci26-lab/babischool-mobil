class TeacherStudentProfileModel {

  final String id;

  final String name;

  final String registration;

  final String gender;

  final String classroom;

  const TeacherStudentProfileModel({

    required this.id,

    required this.name,

    required this.registration,

    required this.gender,

    required this.classroom,

  });

  factory TeacherStudentProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return TeacherStudentProfileModel(

      id: json["id"] ?? "",

      name: json["name"] ?? "",

      registration: json["registration"] ?? "",

      gender: json["gender"] ?? "",

      classroom: json["classroom"] ?? "",

    );

  }

}