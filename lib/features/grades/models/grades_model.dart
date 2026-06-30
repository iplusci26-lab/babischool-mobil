import 'report_card_model.dart';

import 'subject_grade_model.dart';

class GradesModel {

  final ReportCardModel reportCard;

  final List<SubjectGradeModel>
      subjects;

  GradesModel({

    required this.reportCard,

    required this.subjects,
  });

  factory GradesModel.fromJson(

    Map<String,dynamic> json,

  ){

    return GradesModel(

      reportCard:

      ReportCardModel.fromJson(

        json["report_card"],
      ),

      subjects:

      (json["subjects"] as List)

      .map(

        (e)=>

        SubjectGradeModel
        .fromJson(e),

      )

      .toList(),
    );
  }
}