import 'schedule_day_model.dart';

class ScheduleResponseModel {

  final String today;

  final List<ScheduleDayModel> days;

  const ScheduleResponseModel({

    required this.today,

    required this.days,

  });

  factory ScheduleResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return ScheduleResponseModel(

      today: json["today"],

      days: (json["days"] as List)

          .map(

            (e) => ScheduleDayModel.fromJson(e),

          )

          .toList(),

    );

  }

}