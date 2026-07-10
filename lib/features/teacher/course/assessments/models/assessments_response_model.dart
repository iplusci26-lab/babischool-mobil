import 'assessment_model.dart';

class TeacherAssessmentsResponse {

  final String scheduleId;

  final String classroom;

  final String subject;

  final List<TeacherAssessmentModel> assessments;

  const TeacherAssessmentsResponse({

    required this.scheduleId,

    required this.classroom,

    required this.subject,

    required this.assessments,

  });

  factory TeacherAssessmentsResponse.fromJson(

    Map<String, dynamic> json,

  ) {

    final schedule = json["schedule"];

    return TeacherAssessmentsResponse(

      scheduleId: schedule["id"],

      classroom: schedule["classroom"],

      subject: schedule["subject"],

      assessments: (json["assessments"] as List)

          .map(

            (e) => TeacherAssessmentModel.fromJson(e),

          )

          .toList(),

    );

  }

}