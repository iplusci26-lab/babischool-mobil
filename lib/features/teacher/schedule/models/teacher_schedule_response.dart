import 'teacher_schedule_model.dart';

class TeacherScheduleResponse {

  final List<TeacherScheduleModel> schedule;

  const TeacherScheduleResponse({

    required this.schedule,

  });

  factory TeacherScheduleResponse.fromJson(

    Map<String,dynamic> json,

  ){

    return TeacherScheduleResponse(

      schedule: (json["schedule"] as List)

          .map(

            (e)=>TeacherScheduleModel.fromJson(e),

          )

          .toList(),

    );

  }

}