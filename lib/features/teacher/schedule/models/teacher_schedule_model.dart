class TeacherScheduleModel {

  final String id;

  final String weekday;

  final String classroom;

  final String subject;

  final String startTime;

  final String endTime;

  const TeacherScheduleModel({

    required this.id,

    required this.weekday,

    required this.classroom,

    required this.subject,

    required this.startTime,

    required this.endTime,

  });

  factory TeacherScheduleModel.fromJson(

    Map<String,dynamic> json,

  ){

    return TeacherScheduleModel(

      id: json["id"] ?? "",

      weekday: json["weekday"] ?? "",

      classroom: json["classroom"] ?? "",

      subject: json["subject"] ?? "",

      startTime: json["start_time"] ?? "",

      endTime: json["end_time"] ?? "",

    );

  }

}