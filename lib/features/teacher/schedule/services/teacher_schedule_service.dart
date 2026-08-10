import '../../../../core/api/api_client.dart';

import '../models/teacher_schedule_response_model.dart';

class TeacherScheduleService {

  const TeacherScheduleService();

  //----------------------------------------------------------
  // ENDPOINT
  //----------------------------------------------------------

  static const String _endpoint =
      "/mobile/teacher/schedule/";

  //----------------------------------------------------------
  // EMPLOI DU TEMPS
  //----------------------------------------------------------

  Future<TeacherScheduleResponseModel>
      getSchedule() async {

    final response = await ApiClient.dio.get(

      _endpoint,

    );

    return TeacherScheduleResponseModel.fromJson(

      response.data,

    );

  }

  //----------------------------------------------------------
  // RAFRAICHIR
  //----------------------------------------------------------

  Future<TeacherScheduleResponseModel>
      refresh() {

    return getSchedule();

  }

}