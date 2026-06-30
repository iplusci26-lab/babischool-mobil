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

    Map<String,dynamic> json,

  ){

    return AssessmentGradeModel(

      title:
      json["title"],

      type:
      json["type"],

      score:
      double.parse(
        json["score"].toString(),
      ),

      maxScore:
      double.parse(
        json["max_score"].toString(),
      ),

      weight:
      json["weight"],

      date:
      json["date"],
    );
  }
}