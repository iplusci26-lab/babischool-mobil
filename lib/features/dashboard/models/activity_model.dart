class ActivityModel {

  final dynamic id;

  final String type;

  final String title;

  final String description;

  final String? studentName;

  final DateTime date;

  bool isRead;

  final dynamic targetId;

  ActivityModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.studentName,
    required this.date,
    required this.isRead,
    required this.targetId,
  });

  factory ActivityModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ActivityModel(
      id: json["id"],

      type: json["type"],

      title: json["title"],

      description: json["description"] ?? "",

      studentName: json["student_name"],

      date: DateTime.parse(json["date"]),

      isRead: json["is_read"] ?? false,

      targetId: json["target_id"],
    );
  }
}