class TeacherAssessmentModel {

  final String id;

  final String title;

  final String type;

  final DateTime dateAssessment;

  final double maxScore;

  final int weight;

  final bool published;

  const TeacherAssessmentModel({

    required this.id,

    required this.title,

    required this.type,

    required this.dateAssessment,

    required this.maxScore,

    required this.weight,

    required this.published,

  });

  factory TeacherAssessmentModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return TeacherAssessmentModel(

      id: json["id"] ?? "",

      title: json["title"] ?? "",

      type: json["type"] ?? "",

      dateAssessment: DateTime.tryParse(
        json["date_assessment"] ?? "",
      ) ??
      DateTime.now(),

      maxScore: double.parse(
        json["max_score"].toString() ?? "", ),

      weight: json["weight"] ?? "",

      published: json["published"] ?? true,

    );

  }

}