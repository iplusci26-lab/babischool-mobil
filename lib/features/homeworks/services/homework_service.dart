import '../../../core/api/api_client.dart';

import '../models/homework_model.dart';

class HomeworkService {

  Future<List<HomeworkModel>> getHomeworks(
    String studentId,
  ) async {

    final response = await ApiClient.dio.get(

      "/mobile/students/$studentId/homeworks/",

    );

    final List<dynamic> data =

        response.data["homeworks"];

    return data

        .map(

          (e) => HomeworkModel.fromJson(e),

        )

        .toList();

  }

}