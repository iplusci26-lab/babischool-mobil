import 'schedule_model.dart';

class ScheduleDayModel {

  final String weekday;

  final List<ScheduleModel> courses;

  const ScheduleDayModel({

    required this.weekday,

    required this.courses,

  });

  factory ScheduleDayModel.fromJson(
      Map<String, dynamic> json) {

    return ScheduleDayModel(

      weekday: json["weekday"],

      courses: (json["courses"] as List)

          .map(

            (e) => ScheduleModel.fromJson(e),

          )

          .toList(),

    );

  }

}