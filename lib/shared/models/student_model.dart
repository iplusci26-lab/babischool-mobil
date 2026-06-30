class StudentModel {

  final String id;

  final String name;

  final String classroom;

  final String attendanceToday;

  final double balance;

  final double average;

  final int unreadMessages;

  StudentModel({

    required this.id,

    required this.name,

    required this.classroom,

    required this.attendanceToday,

    required this.balance,

    required this.average,

    required this.unreadMessages,
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
    );
  }
}