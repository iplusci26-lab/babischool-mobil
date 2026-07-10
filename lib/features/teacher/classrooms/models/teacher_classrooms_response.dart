import 'teacher_course_model.dart';

class TeacherClassroomsResponse {

  final String teacherId;

  final String teacherName;

  final List<TeacherCourseModel> classrooms;

  const TeacherClassroomsResponse({

    required this.teacherId,

    required this.teacherName,

    required this.classrooms,

  });

  factory TeacherClassroomsResponse.fromJson(
    Map<String, dynamic> json,
  ) {

    final teacher = json["teacher"];

    return TeacherClassroomsResponse(

      teacherId: teacher["id"],

      teacherName: teacher["name"],

      classrooms: (json["classes"] as List)

          .map(

            (e) => TeacherCourseModel.fromJson(e),

          )

          .toList(),

    );

  }

}