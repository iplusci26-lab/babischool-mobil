class TeacherGradeModel {
  final String enrollmentId;

  final String studentId;

  final String? studentNumber;

  final String firstName;

  final String lastName;

  final double? score;

  final double? percentage;

  final String remarks;

  final String? gradeId;

  final bool graded;

  const TeacherGradeModel({
    required this.enrollmentId,
    required this.studentId,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.score,
    required this.percentage,
    required this.remarks,
    required this.gradeId,
    required this.graded,
  });

  factory TeacherGradeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherGradeModel(
      enrollmentId:
          json["enrollment_id"]?.toString() ?? "",

      studentId:
          json["student_id"]?.toString() ?? "",

      studentNumber:
          json["student_number"]?.toString(),

      firstName:
          json["first_name"]?.toString() ?? "",

      lastName:
          json["last_name"]?.toString() ?? "",

      score: _toNullableDouble(
        json["score"],
      ),

      percentage: _toNullableDouble(
        json["percentage"],
      ),

      remarks:
          json["remarks"]?.toString() ?? "",

      gradeId:
          json["grade_id"]?.toString(),

      graded:
          json["graded"] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "enrollment_id": enrollmentId,
      "student_id": studentId,
      "student_number": studentNumber,
      "first_name": firstName,
      "last_name": lastName,
      "score": score,
      "percentage": percentage,
      "remarks": remarks,
      "grade_id": gradeId,
      "graded": graded,
    };
  }

  String get fullName {
    return "$firstName $lastName".trim();
  }

  String get displayName {
    if (studentNumber != null &&
        studentNumber!.isNotEmpty) {
      return "$studentNumber • $fullName";
    }

    return fullName;
  }

  bool get hasScore => score != null;

  bool get hasRemarks =>
      remarks.trim().isNotEmpty;

  TeacherGradeModel copyWith({
    String? enrollmentId,
    String? studentId,
    String? studentNumber,
    String? firstName,
    String? lastName,
    double? score,
    double? percentage,
    String? remarks,
    String? gradeId,
    bool? graded,
  }) {
    return TeacherGradeModel(
      enrollmentId:
          enrollmentId ?? this.enrollmentId,

      studentId:
          studentId ?? this.studentId,

      studentNumber:
          studentNumber ?? this.studentNumber,

      firstName:
          firstName ?? this.firstName,

      lastName:
          lastName ?? this.lastName,

      score:
          score ?? this.score,

      percentage:
          percentage ?? this.percentage,

      remarks:
          remarks ?? this.remarks,

      gradeId:
          gradeId ?? this.gradeId,

      graded:
          graded ?? this.graded,
    );
  }

  @override
  String toString() {
    return "TeacherGradeModel("
        "student: $fullName, "
        "score: $score)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is TeacherGradeModel &&
        other.enrollmentId == enrollmentId;
  }

  @override
  int get hashCode =>
      enrollmentId.hashCode;
}

// ============================================================
// HELPERS
// ============================================================

double? _toNullableDouble(
  dynamic value,
) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(
    value.toString(),
  );
}