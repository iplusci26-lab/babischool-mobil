import 'teacher_assessment_model.dart';
import 'teacher_grade_model.dart';

class TeacherAssessmentGradesResponseModel {
  final TeacherAssessmentModel assessment;

  final List<TeacherGradeModel> students;

  final TeacherAssessmentStatisticsModel statistics;

  const TeacherAssessmentGradesResponseModel({
    required this.assessment,
    required this.students,
    required this.statistics,
  });

  factory TeacherAssessmentGradesResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final studentsJson = json["students"];

    return TeacherAssessmentGradesResponseModel(
      assessment: TeacherAssessmentModel.fromJson(
        Map<String, dynamic>.from(
          json["assessment"] ?? {},
        ),
      ),
      students: studentsJson is List
          ? studentsJson
              .map(
                (item) => TeacherGradeModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const [],
      statistics:
          TeacherAssessmentStatisticsModel.fromJson(
        Map<String, dynamic>.from(
          json["statistics"] ?? {},
        ),
      ),
    );
  }
}

// ============================================================
// STATISTIQUES
// ============================================================

class TeacherAssessmentStatisticsModel {
  final int totalStudents;

  final int graded;

  final int pending;

  final double average;

  final double highest;

  final double lowest;

  final double completionPercentage;

  const TeacherAssessmentStatisticsModel({
    required this.totalStudents,
    required this.graded,
    required this.pending,
    required this.average,
    required this.highest,
    required this.lowest,
    required this.completionPercentage,
  });

  factory TeacherAssessmentStatisticsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherAssessmentStatisticsModel(
      totalStudents: _toInt(
        json["total_students"],
      ),
      graded: _toInt(
        json["graded"],
      ),
      pending: _toInt(
        json["pending"],
      ),
      average: _toDouble(
        json["average"],
      ),
      highest: _toDouble(
        json["highest"],
      ),
      lowest: _toDouble(
        json["lowest"],
      ),
      completionPercentage: _toDouble(
        json["completion_percentage"],
      ),
    );
  }

  bool get isComplete => pending == 0;

  double get completionRatio {
    if (totalStudents == 0) {
      return 0;
    }

    return graded / totalStudents;
  }
}

// ============================================================
// HELPERS
// ============================================================

double _toDouble(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(
        value.toString(),
      ) ??
      0;
}

int _toInt(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(
        value.toString(),
      ) ??
      0;
}