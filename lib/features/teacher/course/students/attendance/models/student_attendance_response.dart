import 'student_attendance_model.dart';

class StudentAttendanceResponse {

  final List<StudentAttendanceModel> attendance;

  const StudentAttendanceResponse({

    required this.attendance,

  });

  factory StudentAttendanceResponse.fromJson(
    Map<String, dynamic> json,
  ) {

    return StudentAttendanceResponse(

      attendance: (json["attendance"] as List)

          .map(

            (e) => StudentAttendanceModel.fromJson(e),

          )

          .toList(),

    );

  }

}