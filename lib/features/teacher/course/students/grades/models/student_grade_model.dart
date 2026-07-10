class StudentGradeModel {

  final String assessment;

  final double score;

  final double maxScore;

  const StudentGradeModel({

    required this.assessment,

    required this.score,

    required this.maxScore,

  });

  factory StudentGradeModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return StudentGradeModel(

      assessment: json["assessment"] ?? "",

      score: (json["score"] ?? 0).toDouble(),

      maxScore: (json["max_score"] ?? 0).toDouble(),

    );

  }

}