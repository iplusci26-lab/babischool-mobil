import 'teacher_student_model.dart';

class TeacherStudentsResponse {

  final String classroomId;

  final String classroomName;

  final List<TeacherStudentModel> students;

  const TeacherStudentsResponse({

    required this.classroomId,

    required this.classroomName,

    required this.students,

  });

  factory TeacherStudentsResponse.fromJson(

    Map<String, dynamic> json,

  ) {

    final classroom = json["classroom"];

    return TeacherStudentsResponse(

      classroomId: classroom["id"],

      classroomName: classroom["name"],

      students: (json["students"] as List)

          .map(

            (e) => TeacherStudentModel.fromJson(e),

          )

          .toList(),

    );

  }

}