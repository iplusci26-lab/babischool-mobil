import 'assessment_status.dart';


class AssessmentModel {

  final String id;

  final String title;

  final String subject;

  final String teacher;

  final String type;

  final String typeIcon;

  final String date;

  final String dateLabel;

  final String time;

  final double maxScore;

  final int weight;

  final AssessmentStatus status;

  final String statusLabel;

  final String color;

  final double? score;

  final String dateGroup;

  const AssessmentModel({

    required this.id,

    required this.title,

    required this.subject,

    required this.teacher,

    required this.type,

    required this.typeIcon,

    required this.date,

    required this.dateLabel,

    required this.time,

    required this.maxScore,

    required this.weight,

    required this.status,

    required this.statusLabel,

    required this.color,

    required this.dateGroup,

    this.score,

  });

  bool get isGraded =>
      status == AssessmentStatus.graded;

  bool get hasScore =>
      score != null;

  bool get isToday =>
      status == AssessmentStatus.today;

  bool get isUpcoming =>
      status == AssessmentStatus.upcoming;

  bool get isLate =>
      status == AssessmentStatus.late;

  bool get isCancelled =>
      status == AssessmentStatus.cancelled;

  factory AssessmentModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return AssessmentModel(

      id:
      json["id"].toString(),

      title:
      json["title"] ?? "",

      subject:
      json["subject"] ?? "",

      teacher:
      json["teacher"] ?? "",

      type:
      json["type"] ?? "",

      typeIcon:
      json["type_icon"] ?? "",

      date:
      json["date"] ?? "",

      dateGroup:
      json["date_group"] ?? "later",

      dateLabel:
      json["date_label"] ?? "",

      time:
      json["time"] ?? "",

      maxScore:
      double.tryParse(
        json["max_score"].toString(),
      ) ??
      20,

      weight:
      json["weight"] ?? 1,

      status:

      AssessmentStatusExtension.fromString(

        json["status"] ?? "upcoming",

      ),

      statusLabel:

      json["status_label"] ?? "",

      color:

      json["color"] ?? "blue",

      score:

      json["score"] == null

      ? null

      : double.tryParse(

          json["score"].toString(),

        ),

    );
  }
}