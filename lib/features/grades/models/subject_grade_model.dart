import 'assessment_grade_model.dart';

class SubjectGradeModel {
  final String subject;
  final String teacher;
  final int coefficient;
  final double average;
  final List<AssessmentGradeModel> grades;

  SubjectGradeModel({
    required this.subject,
    required this.teacher,
    required this.coefficient,
    required this.average,
    required this.grades,
  });

  factory SubjectGradeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final grades = (json["grades"] as List? ?? [])
        .map(
          (e) => AssessmentGradeModel.fromJson(e),
        )
        .toList();

    // ========================================================
    // TRI DES NOTES
    //
    // Plus récente → plus ancienne
    // ========================================================

    grades.sort(
      (a, b) {
        final dateA = a.parsedDate;
        final dateB = b.parsedDate;

        // Les notes sans date vont à la fin.
        if (dateA == null && dateB == null) {
          return 0;
        }

        if (dateA == null) {
          return 1;
        }

        if (dateB == null) {
          return -1;
        }

        return dateB.compareTo(dateA);
      },
    );

    return SubjectGradeModel(
      subject: json["subject"] ?? "",
      teacher: json["teacher"] ?? "",
      coefficient:
          (json["coefficient"] as num?)?.toInt() ?? 0,
      average:
          (json["average"] as num?)?.toDouble() ?? 0.0,
      grades: grades,
    );
  }

  // ==========================================================
  // DATE DE LA NOTE LA PLUS RÉCENTE
  // ==========================================================

  DateTime? get latestGradeDate {
    if (grades.isEmpty) {
      return null;
    }

    return grades.first.parsedDate;
  }
}