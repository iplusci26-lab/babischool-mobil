class StaffAnnouncementTarget {
  final String targetType;
  final String? classroom;
  final String? classroomName;
  final String? classroomLevel;
  final String? classroomLevelName;

  const StaffAnnouncementTarget({
    required this.targetType,
    this.classroom,
    this.classroomName,
    this.classroomLevel,
    this.classroomLevelName,
  });

  factory StaffAnnouncementTarget.fromJson(Map<String, dynamic> json) {
    return StaffAnnouncementTarget(
      targetType: (json['target_type'] ?? '').toString(),
      classroom: json['classroom']?.toString(),
      classroomName: json['classroom_name']?.toString(),
      classroomLevel: json['classroom_level']?.toString(),
      classroomLevelName: json['classroom_level_name']?.toString(),
    );
  }

  String get displayName {
    switch (targetType) {
      case 'classroom':
        return classroomName ?? 'Classe';

      case 'classroom_level':
      case 'level':
        return classroomLevelName ?? 'Niveau';

      case 'school':
        return 'Toute l’école';

      default:
        return targetType;
    }
  }
}

class StaffAnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final String priority;
  final String? attachment;
  final DateTime? publishAt;
  final DateTime? expireAt;
  final bool isActive;
  final bool sendNotification;
  final String createdByName;
  final List<StaffAnnouncementTarget> targets;

  const StaffAnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.priority,
    this.attachment,
    this.publishAt,
    this.expireAt,
    required this.isActive,
    required this.sendNotification,
    required this.createdByName,
    required this.targets,
  });

  factory StaffAnnouncementModel.fromJson(Map<String, dynamic> json) {
    final rawTargets = json['targets'] as List? ?? [];

    return StaffAnnouncementModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      category: (json['category'] ?? 'general').toString(),
      priority: (json['priority'] ?? 'normal').toString(),
      attachment: json['attachment']?.toString(),
      publishAt: DateTime.tryParse(json['publish_at']?.toString() ?? ''),
      expireAt: DateTime.tryParse(json['expire_at']?.toString() ?? ''),
      isActive: json['is_active'] == true,
      sendNotification: json['send_notification'] != false,
      createdByName: (json['created_by_name'] ?? '').toString(),
      targets: rawTargets
          .map(
            (item) => StaffAnnouncementTarget.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
    );
  }

  String get priorityLabel {
    switch (priority) {
      case 'important':
        return 'Important';
      case 'urgent':
        return 'Urgent';
      default:
        return 'Normal';
    }
  }

  String get categoryLabel {
    const labels = {
      'general': 'Général',
      'finance': 'Finance',
      'academic': 'Pédagogique',
      'discipline': 'Discipline',
      'holiday': 'Congé',
      'meeting': 'Réunion',
      'service': 'Note de service',
      'emergency': 'Urgence',
      'exam': 'Examen',
      'other': 'Autre',
    };

    return labels[category] ?? category;
  }

  String get targetLabel {
    if (targets.isEmpty) return 'Destinataires non précisés';

    return targets.map((target) => target.displayName).join(', ');
  }
}
