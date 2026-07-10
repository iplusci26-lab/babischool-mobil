class AttendanceStudentModel {

  final String enrollmentId;

  final String studentId;

  final String name;

  String status;

  final int minutesLate;

  final String remarks;

  AttendanceStudentModel({

    required this.enrollmentId,

    required this.studentId,

    required this.name,

    required this.status,

    required this.minutesLate,

    required this.remarks,

  });

  factory AttendanceStudentModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return AttendanceStudentModel(

      enrollmentId: json["enrollment_id"],

      studentId: json["student_id"],

      name: json["name"],

      status: json["status"],

      minutesLate: json["minutes_late"] ?? 0,

      remarks: json["remarks"] ?? "",

    );

  }

  Map<String, dynamic> toJson() {

    return {

      "enrollment_id": enrollmentId,

      "status": status,

      "minutes_late": minutesLate,

      "remarks": remarks,

    };

  }

}