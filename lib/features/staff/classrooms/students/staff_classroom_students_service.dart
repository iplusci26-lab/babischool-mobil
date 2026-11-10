
import '../../../../core/api/api_client.dart';
import '../models/staff_classroom_model.dart';
import 'models/staff_student_model.dart';

class StaffClassroomStudentsService {
  static Future<Map<String, dynamic>> getStudents(
    String classroomId,
  ) async {
    final response = await ApiClient.dio.get(
      '/mobile/staff/classrooms/$classroomId/students/',
    );

    final data = response.data as Map<String, dynamic>;

    final classroom = StaffClassroomModel(
      id: data['classroom']['id'].toString(),
      name: (data['classroom']['name'] ?? '').toString(),
      classroomLevel: '',
      cycle: '',
      studentsCount: (data['total_students'] as num?)?.toInt() ?? 0,
    );

    final List<dynamic> studentsJson =
        data['students'] as List<dynamic>;

    final students = studentsJson
        .map(
          (json) => StaffStudentModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();

    return {
      'classroom': classroom,
      'students': students,
      'total_students': data['total_students'] ?? 0,
    };
  }
}
