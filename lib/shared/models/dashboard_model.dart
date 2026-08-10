import '../../features/dashboard/models/activity_model.dart';
import 'student_model.dart';

class DashboardModel {

  final String parentName;

  final List<StudentModel> students;

  final List<ActivityModel> activities;

  DashboardModel({

    required this.parentName,

    required this.students,

    required this.activities,
  });

  factory DashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return DashboardModel(

      parentName:
          json["parent"]["name"],

      students:

          (json["children"] as List)

              .map(
                (e) =>
                    StudentModel.fromJson(e),
              )

              .toList(),

      activities:

          (json["activities"] as List)

              .map(
                (e) =>
                    ActivityModel.fromJson(e),
              )

              .toList(),
    );
  }
}