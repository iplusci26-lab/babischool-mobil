import 'attendance_student_model.dart';

class AttendanceResponseModel {

  final String classroomId;

  final String classroomName;

  final String sessionId;

  final String sessionDate;

  final List<AttendanceStudentModel> students;

  const AttendanceResponseModel({

    required this.classroomId,

    required this.classroomName,

    required this.sessionId,

    required this.sessionDate,

    required this.students,

  });

  factory AttendanceResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {

    final classroom = json["classroom"];

    return AttendanceResponseModel(

      classroomId: classroom["id"],

      classroomName: classroom["name"],

      sessionId: json["session"],

      sessionDate: json["session_date"],

      students: (json["students"] as List)

          .map(
            (e) => AttendanceStudentModel.fromJson(e),
          )
          .toList(),

    );

  }

}