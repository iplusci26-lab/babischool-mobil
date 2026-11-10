
import '../../../core/api/api_client.dart';
import 'models/staff_classroom_model.dart';

class StaffClassroomService {
  static Future<List<StaffClassroomModel>> getClassrooms() async {
    final response = await ApiClient.dio.get(
      '/mobile/staff/classrooms/',
    );

    final List<dynamic> data = response.data as List<dynamic>;

    return data
        .map(
          (json) => StaffClassroomModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
