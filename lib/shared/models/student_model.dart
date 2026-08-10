class StudentModel {

  final String id;

  final String name;

  final String classroom;

  final String attendanceToday;

  final double balance;

  final double average;

  final int unreadMessages;

  final int absenceHours;

  final int absenceCount;

  final int lateCount;

  final int presentCount;

  StudentModel({

    required this.id,

    required this.name,

    required this.classroom,

    required this.attendanceToday,

    required this.balance,

    required this.average,

    required this.unreadMessages,

    required this.absenceHours,

    required this.absenceCount,

    required this.lateCount,

    required this.presentCount,
  });

  factory StudentModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return StudentModel(

      id:
      json["id"] ?? "",

      name:
      json["name"] ?? "",

      classroom:
      json["classroom"] ?? "",

      attendanceToday:
      json["attendance_today"] ?? "",

      balance:
      double.tryParse(
        json["balance"].toString(),
      ) ?? 0,

      average:
      double.tryParse(
        json["average"].toString(),
      ) ?? 0,

      unreadMessages:
      json["unread_messages"] ?? 0,

      absenceHours: json["absence_hours"] ?? 0,

      absenceCount: json["absence_count"] ?? 0,

      lateCount: json["late_count"] ?? 0,

      presentCount: json["present_count"] ?? 0,
    );
  }
}