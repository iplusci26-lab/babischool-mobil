import 'student_model.dart';

class DashboardModel {

  final String parentName;

  final List<StudentModel> students;

  DashboardModel({

    required this.parentName,

    required this.students,
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
    );
  }
}