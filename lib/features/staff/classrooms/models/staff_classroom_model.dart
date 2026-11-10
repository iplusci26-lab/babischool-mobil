
class StaffClassroomModel {
  final String id;
  final String name;
  final String classroomLevel;
  final String? classroomLevelId;
  final String cycle;
  final int studentsCount;

  const StaffClassroomModel({
    required this.id,
    required this.name,
    required this.classroomLevel,
    this.classroomLevelId,
    required this.cycle,
    required this.studentsCount,
  });

  factory StaffClassroomModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StaffClassroomModel(
      id: json['id'].toString(),
      name: (json['name'] ?? '').toString(),
      classroomLevel:
          (json['classroom_level'] ?? '').toString(),
      classroomLevelId:
          json['classroom_level_id']?.toString(),
      cycle: (json['cycle'] ?? '').toString(),
      studentsCount:
          (json['students_count'] as num?)?.toInt() ?? 0,
    );
  }
}
