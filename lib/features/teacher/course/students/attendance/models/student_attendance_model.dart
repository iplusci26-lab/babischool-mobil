class StudentAttendanceModel {

  final String date;

  final String status;

  const StudentAttendanceModel({

    required this.date,

    required this.status,

  });

  factory StudentAttendanceModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return StudentAttendanceModel(

      date: json["date"] ?? "",

      status: json["status"] ?? "",

    );

  }

}