import 'teacher_attendance_session_model.dart';
import 'teacher_attendance_student_model.dart';

class TeacherAttendanceResponseModel {
  //----------------------------------------------------------
  // SESSION
  //----------------------------------------------------------

  final TeacherAttendanceSessionModel session;

  //----------------------------------------------------------
  // ÉLÈVES
  //----------------------------------------------------------

  final List<TeacherAttendanceStudentModel> students;

  //----------------------------------------------------------
  // STATISTIQUES
  //----------------------------------------------------------

  final int totalStudents;

  final int present;

  final int absent;

  final int late;

  const TeacherAttendanceResponseModel({
    required this.session,
    required this.students,
    required this.totalStudents,
    required this.present,
    required this.absent,
    required this.late,
  });

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  factory TeacherAttendanceResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherAttendanceResponseModel(
      session: TeacherAttendanceSessionModel.fromJson(
        json["session"],
      ),

      students:
          (json["students"] as List? ?? [])
              .map(
                (student) =>
                    TeacherAttendanceStudentModel.fromJson(
                  student,
                ),
              )
              .toList(),

      totalStudents:
          json["total_students"] ?? 0,

      present:
          json["present"] ?? 0,

      absent:
          json["absent"] ?? 0,

      late:
          json["late"] ?? 0,
    );
  }

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  Map<String, dynamic> toJson() {
    return {
      "session": session.toJson(),

      "students":
          students
              .map(
                (student) => student.toJson(),
              )
              .toList(),

      "total_students":
          totalStudents,

      "present":
          present,

      "absent":
          absent,

      "late":
          late,
    };
  }

  //----------------------------------------------------------
  // HELPERS
  //----------------------------------------------------------

  bool get isEmpty =>
      students.isEmpty;

  bool get isNotEmpty =>
      students.isNotEmpty;

  //----------------------------------------------------------
  // POURCENTAGES
  //----------------------------------------------------------

  double get presentPercentage {
    if (totalStudents == 0) {
      return 0;
    }

    return present / totalStudents;
  }

  double get absentPercentage {
    if (totalStudents == 0) {
      return 0;
    }

    return absent / totalStudents;
  }

  double get latePercentage {
    if (totalStudents == 0) {
      return 0;
    }

    return late / totalStudents;
  }

  //----------------------------------------------------------
  // ÉLÈVES
  //----------------------------------------------------------

  List<TeacherAttendanceStudentModel>
      get presentStudents {
    return students
        .where(
          (student) => student.isPresent,
        )
        .toList();
  }

  List<TeacherAttendanceStudentModel>
      get absentStudents {
    return students
        .where(
          (student) => student.isAbsent,
        )
        .toList();
  }

  List<TeacherAttendanceStudentModel>
      get lateStudents {
    return students
        .where(
          (student) => student.isLate,
        )
        .toList();
  }

  //----------------------------------------------------------
  // APPEL COMPLET
  //----------------------------------------------------------

  bool get allStudentsProcessed {
    return students.length == totalStudents;
  }

  //----------------------------------------------------------
  // COPY WITH
  //----------------------------------------------------------

  TeacherAttendanceResponseModel copyWith({
    TeacherAttendanceSessionModel? session,

    List<TeacherAttendanceStudentModel>? students,

    int? totalStudents,

    int? present,

    int? absent,

    int? late,
  }) {
    return TeacherAttendanceResponseModel(
      session:
          session ?? this.session,

      students:
          students ?? this.students,

      totalStudents:
          totalStudents ?? this.totalStudents,

      present:
          present ?? this.present,

      absent:
          absent ?? this.absent,

      late:
          late ?? this.late,
    );
  }

  //----------------------------------------------------------
  // TOSTRING
  //----------------------------------------------------------

  @override
  String toString() {
    return "TeacherAttendanceResponseModel("
        "session: ${session.id}, "
        "students: ${students.length}, "
        "present: $present, "
        "absent: $absent, "
        "late: $late)";
  }

  //----------------------------------------------------------
  // EQUALITY
  //----------------------------------------------------------

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other
            is TeacherAttendanceResponseModel &&
        other.session == session;
  }

  @override
  int get hashCode =>
      session.hashCode;
}