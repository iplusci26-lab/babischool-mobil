import 'assessment_grade_model.dart';

class SubjectGradeModel {

  final String subject;

  final String teacher;

  final int coefficient;

  final double average;

  final List<AssessmentGradeModel>
      grades;

  SubjectGradeModel({

    required this.subject,

    required this.teacher,

    required this.coefficient,

    required this.average,

    required this.grades,
  });

  factory SubjectGradeModel.fromJson(

    Map<String,dynamic> json,

  ){

    return SubjectGradeModel(

      subject:
      json["subject"],

      teacher:
      json["teacher"],

      coefficient:
      json["coefficient"],

      average:
      double.parse(
        json["average"].toString(),
      ),

      grades:

      (json["grades"] as List)

      .map(

        (e)=>

        AssessmentGradeModel
        .fromJson(e),

      )

      .toList(),
    );
  }
}