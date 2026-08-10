import 'teacher_homework_model.dart';

class TeacherHomeworksResponse {

  final String scheduleId;

  final String classroom;

  final String subject;

  final List<TeacherHomeworkModel> homeworks;

  const TeacherHomeworksResponse({

    required this.scheduleId,

    required this.classroom,

    required this.subject,

    required this.homeworks,

  });

  factory TeacherHomeworksResponse.fromJson(

    Map<String, dynamic> json,

  ) {

    final schedule = json["schedule"];

    return TeacherHomeworksResponse(

      scheduleId: schedule["id"],

      classroom: schedule["classroom"],

      subject: schedule["subject"],

      homeworks: (json["homeworks"] as List)

          .map(

            (e) => TeacherHomeworkModel.fromJson(e),

          )

          .toList(),

    );

  }

}