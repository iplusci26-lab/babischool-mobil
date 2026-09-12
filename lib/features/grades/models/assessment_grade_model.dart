class AssessmentGradeModel {
  final String title;
  final String type;
  final double score;
  final double maxScore;
  final int weight;
  final String date;

  AssessmentGradeModel({
    required this.title,
    required this.type,
    required this.score,
    required this.maxScore,
    required this.weight,
    required this.date,
  });

  factory AssessmentGradeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AssessmentGradeModel(
      title: json["title"] ?? "",
      type: json["type"] ?? "",
      score: (json["score"] as num).toDouble(),
      maxScore: (json["max_score"] as num).toDouble(),
      weight: (json["weight"] as num).toInt(),
      date: json["date"]?.toString() ?? "",
    );
  }

  // ==========================================================
  // DATE POUR LE TRI
  // ==========================================================

  DateTime? get parsedDate {
    if (date.isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(date);
    } catch (_) {
      return null;
    }
  }
}