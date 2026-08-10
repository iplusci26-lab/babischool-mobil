class TeacherAttendanceStudentModel {

  //----------------------------------------------------------
  // IDENTIFIANTS
  //----------------------------------------------------------

  final String enrollmentId;

  final String studentId;

  final String? recordId;

  //----------------------------------------------------------
  // IDENTITÉ
  //----------------------------------------------------------

  final String firstName;

  final String lastName;

  final String? studentNumber;

  //----------------------------------------------------------
  // PRÉSENCE
  //----------------------------------------------------------

  final String status;

  final int minutesLate;

  final String remarks;

  const TeacherAttendanceStudentModel({

    required this.enrollmentId,

    required this.studentId,

    this.recordId,

    required this.firstName,

    required this.lastName,

    this.studentNumber,

    required this.status,

    required this.minutesLate,

    required this.remarks,

  });

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  factory TeacherAttendanceStudentModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return TeacherAttendanceStudentModel(

      enrollmentId:
          json["enrollment_id"].toString(),

      studentId:
          json["student_id"].toString(),

      recordId:
          json["record_id"]?.toString(),

      firstName:
          json["first_name"] ?? "",

      lastName:
          json["last_name"] ?? "",

      studentNumber:
          json["student_number"]?.toString(),

      status:
          json["status"] ?? "PRESENT",

      minutesLate:
          json["minutes_late"] ?? 0,

      remarks:
          json["remarks"] ?? "",

    );

  }

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  Map<String, dynamic> toJson() {

    return {

      "enrollment_id":
          enrollmentId,

      "student_id":
          studentId,

      "record_id":
          recordId,

      "first_name":
          firstName,

      "last_name":
          lastName,

      "student_number":
          studentNumber,

      "status":
          status,

      "minutes_late":
          minutesLate,

      "remarks":
          remarks,

    };

  }

  //----------------------------------------------------------
  // HELPERS
  //----------------------------------------------------------

  String get fullName {

    return "$firstName $lastName".trim();

  }

  bool get isPresent {

    return status == "PRESENT";

  }

  bool get isAbsent {

    return status == "ABSENT";

  }

  bool get isLate {

    return status == "LATE";

  }

  bool get requiresJustification {

    return isAbsent || isLate;

  }

  //----------------------------------------------------------
  // COPY WITH
  //----------------------------------------------------------

  TeacherAttendanceStudentModel copyWith({

    String? enrollmentId,

    String? studentId,

    String? recordId,

    String? firstName,

    String? lastName,

    String? studentNumber,

    String? status,

    int? minutesLate,

    String? remarks,

  }) {

    return TeacherAttendanceStudentModel(

      enrollmentId:
          enrollmentId ?? this.enrollmentId,

      studentId:
          studentId ?? this.studentId,

      recordId:
          recordId ?? this.recordId,

      firstName:
          firstName ?? this.firstName,

      lastName:
          lastName ?? this.lastName,

      studentNumber:
          studentNumber ?? this.studentNumber,

      status:
          status ?? this.status,

      minutesLate:
          minutesLate ?? this.minutesLate,

      remarks:
          remarks ?? this.remarks,

    );

  }

  //----------------------------------------------------------
  // EQUALITY
  //----------------------------------------------------------

  @override
  bool operator ==(Object other) {

    if (identical(this, other)) {

      return true;

    }

    return other is TeacherAttendanceStudentModel &&
        other.enrollmentId ==
            enrollmentId;

  }

  @override
  int get hashCode =>
      enrollmentId.hashCode;

  //----------------------------------------------------------
  // TOSTRING
  //----------------------------------------------------------

  @override
  String toString() {

    return "TeacherAttendanceStudentModel("
        "enrollmentId: $enrollmentId, "
        "name: $fullName, "
        "status: $status)";

  }

}