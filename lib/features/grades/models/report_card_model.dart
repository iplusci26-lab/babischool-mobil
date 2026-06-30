class ReportCardModel {

  final double average;

  final int? rank;

  final int studentsCount;

  final bool published;

  final String remarks;

  ReportCardModel({

    required this.average,

    required this.rank,

    required this.studentsCount,

    required this.published,

    required this.remarks,
  });

  factory ReportCardModel.fromJson(

    Map<String,dynamic> json,

  ){

    return ReportCardModel(

      average:

      double.parse(
        json["average"].toString(),
      ),

      rank:
      json["rank"],

      studentsCount:
      json["students_count"],

      published:
      json["published"],

      remarks:
      json["remarks"] ?? "",
    );
  }
}