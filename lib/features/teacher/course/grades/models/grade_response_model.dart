import 'grade_student_model.dart';

class GradesResponseModel {

  final String assessmentId;

  final String title;

  final double maxScore;

  final int weight;

  final List<GradeStudentModel> students;

  const GradesResponseModel({

    required this.assessmentId,

    required this.title,

    required this.maxScore,

    required this.weight,

    required this.students,

  });

  factory GradesResponseModel.fromJson(

    Map<String, dynamic> json,

  ) {

    final assessment = json["assessment"];

    return GradesResponseModel(

      assessmentId: assessment["id"],

      title: assessment["title"],

      maxScore: double.parse(

        assessment["max_score"].toString(),

      ),

      weight: assessment["weight"],

      students: (json["students"] as List)

          .map(

            (e) => GradeStudentModel.fromJson(e),

          )

          .toList(),

    );

  }

}