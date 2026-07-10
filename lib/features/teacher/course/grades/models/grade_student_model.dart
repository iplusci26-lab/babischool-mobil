class GradeStudentModel {

  final String enrollmentId;

  final String studentId;

  final String student;

  double? score;

  String remarks;

  double? percentage;

  GradeStudentModel({

    required this.enrollmentId,

    required this.studentId,

    required this.student,

    required this.score,

    required this.remarks,

    required this.percentage,

  });

  factory GradeStudentModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return GradeStudentModel(

      enrollmentId: json["enrollment_id"],

      studentId: json["student_id"],

      student: json["student"],

      score: json["score"] == null

          ? null

          : double.parse(

              json["score"].toString(),

            ),

      remarks: json["remarks"] ?? "",

      percentage: json["percentage"] == null

          ? null

          : double.parse(

              json["percentage"].toString(),

            ),

    );

  }

  Map<String, dynamic> toJson() {

    return {

      "enrollment_id": enrollmentId,

      "score": score,

      "remarks": remarks,

    };

  }

}