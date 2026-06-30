class StudentDetailModel {

  final String id;

  final String fullName;

  final String studentNumber;

  final String gender;

  final String classroom;

  final String cycle;

  final String dateOfBirth;

  StudentDetailModel({

    required this.id,

    required this.fullName,

    required this.studentNumber,

    required this.gender,

    required this.classroom,

    required this.cycle,

    required this.dateOfBirth,
  });

  factory StudentDetailModel.fromJson(
    Map<String,dynamic> json,
  ) {

    return StudentDetailModel(

      id: json["id"],

      fullName:
      json["full_name"],

      studentNumber:
      json["student_number"],

      gender:
      json["gender"] ?? "",

      classroom:
      json["classroom"] ?? "",

      cycle:
      json["cycle"] ?? "",

      dateOfBirth:
      json["date_of_birth"] ?? "",
    );
  }
}