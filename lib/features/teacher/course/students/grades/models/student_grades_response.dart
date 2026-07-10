import 'student_grade_model.dart';

class StudentGradesResponse {

  final List<StudentGradeModel> grades;

  const StudentGradesResponse({

    required this.grades,

  });

  factory StudentGradesResponse.fromJson(
    Map<String, dynamic> json,
  ) {

    return StudentGradesResponse(

      grades: (json["grades"] as List)

          .map(

            (e) => StudentGradeModel.fromJson(e),

          )

          .toList(),

    );

  }

}