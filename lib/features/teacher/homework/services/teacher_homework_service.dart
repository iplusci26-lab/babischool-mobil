import '../../../../core/api/api_client.dart';
import '../models/teacher_homework_model.dart';

class TeacherHomeworkService {
  const TeacherHomeworkService();

  // ==========================================================
  // LISTE DES DEVOIRS
  // ==========================================================

  Future<TeacherHomeworkResponseModel> getHomeworks(
    String scheduleId,
  ) async {
    final response = await ApiClient.dio.get(
      "/mobile/teacher/schedules/"
      "$scheduleId/homeworks/",
    );

    return TeacherHomeworkResponseModel.fromJson(
      response.data,
    );
  }

  // ==========================================================
  // CREATION
  // ==========================================================

  Future<String> createHomework({
    required String scheduleId,
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    final response = await ApiClient.dio.post(
      "/mobile/teacher/schedules/"
      "$scheduleId/homeworks/",
      data: {
        "title": title.trim(),
        "description": description.trim(),
        "due_date": _formatDate(dueDate),
      },
    );

    return response.data["id"]?.toString() ?? "";
  }

  // ==========================================================
  // MODIFICATION
  // ==========================================================

  Future<void> updateHomework({
    required String homeworkId,
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    await ApiClient.dio.put(
      "/mobile/teacher/homeworks/"
      "$homeworkId/",
      data: {
        "title": title.trim(),
        "description": description.trim(),
        "due_date": _formatDate(dueDate),
      },
    );
  }

  // ==========================================================
  // SUPPRESSION
  // ==========================================================

  Future<void> deleteHomework(
    String homeworkId,
  ) async {
    await ApiClient.dio.delete(
      "/mobile/teacher/homeworks/"
      "$homeworkId/",
    );
  }

  // ==========================================================
  // DATE
  // ==========================================================

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }
}