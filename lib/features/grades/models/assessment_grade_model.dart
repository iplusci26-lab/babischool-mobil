
class AssessmentGradeModel {
  final String title;
  final String type;
  final double score;
  final double maxScore;
  final double weight;
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
      title: json["title"]?.toString() ?? "",
      type: json["type"]?.toString() ?? "",
      score: (json["score"] as num?)?.toDouble() ?? 0.0,
      maxScore: (json["max_score"] as num?)?.toDouble() ?? 0.0,
      weight: (json["weight"] as num?)?.toDouble() ?? 0.0,
      date: json["date"]?.toString() ?? "",
    );
  }

  // Date utilisée pour le tri.
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

  // Affiche 1 au lieu de 1.0, mais conserve 0.5 et 1.5.
  String get formattedWeight {
    if (weight == weight.truncateToDouble()) {
      return weight.toInt().toString();
    }

    return weight.toString();
  }
}
