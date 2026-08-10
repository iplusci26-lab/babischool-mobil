class AnnouncementModel {
  final String id;

  final String title;

  final String content;

  final String category;

  final String categoryDisplay;

  final String priority;

  final String priorityDisplay;

  final String? attachmentUrl;

  final String createdBy;

  final DateTime publishAt;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.categoryDisplay,
    required this.priority,
    required this.priorityDisplay,
    required this.createdBy,
    required this.publishAt,
    this.attachmentUrl,
  });

  factory AnnouncementModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AnnouncementModel(
      id: json["id"],

      title: json["title"] ?? "",

      content: json["content"] ?? "",

      category: json["category"] ?? "",

      categoryDisplay:
          json["category_display"] ?? "",

      priority:
          json["priority"] ?? "normal",

      priorityDisplay:
          json["priority_display"] ?? "",

      createdBy:
          json["created_by_name"] ?? "",

      attachmentUrl:
          json["attachment_url"],

      publishAt: DateTime.parse(
        json["publish_at"],
      ),
    );
  }
}