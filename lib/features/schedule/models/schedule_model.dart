class ScheduleModel {

  final String id;

  final String subject;

  final String teacher;

  final String weekday;

  final String startTime;

  final String endTime;

  final String duration;

  final String color;

  final bool isCurrent;

  final bool isNext;

  const ScheduleModel({

    required this.id,

    required this.subject,

    required this.teacher,

    required this.weekday,

    required this.startTime,

    required this.endTime,

    required this.duration,

    required this.color,

    required this.isCurrent,

    required this.isNext,

  });

  factory ScheduleModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return ScheduleModel(

      id: json["id"],

      subject: json["subject"],

      teacher: json["teacher"],

      weekday: json["weekday"],

      startTime: json["start_time"],

      endTime: json["end_time"],

      duration: json["duration"],

      color: json["color"],

      isCurrent: json["is_current"],

      isNext: json["is_next"],

    );

  }

}