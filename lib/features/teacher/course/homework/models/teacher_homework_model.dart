class TeacherHomeworkModel {

  final String id;

  final String title;

  final String description;

  final DateTime assignedDate;

  final DateTime dueDate;

  final bool published;

  final bool hasAttachment;

  const TeacherHomeworkModel({

    required this.id,

    required this.title,

    required this.description,

    required this.assignedDate,

    required this.dueDate,

    required this.published,

    required this.hasAttachment,

  });

  factory TeacherHomeworkModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return TeacherHomeworkModel(

      id: json["id"],

      title: json["title"],

      description: json["description"],

      assignedDate: DateTime.parse(

        json["assigned_date"],

      ),

      dueDate: DateTime.parse(

        json["due_date"],

      ),

      published: json["published"],

      hasAttachment: json["has_attachment"],

    );

  }

}