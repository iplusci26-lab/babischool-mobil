import '../../../../core/api/api_client.dart';

import '../models/teacher_classrooms_response_model.dart';

class TeacherClassroomsService {

  const TeacherClassroomsService();

  //----------------------------------------------------------
  // ENDPOINT
  //----------------------------------------------------------

  static const String _endpoint =
      "/mobile/teacher/classrooms/";

  //----------------------------------------------------------
  // MES CLASSES
  //----------------------------------------------------------

  Future<TeacherClassroomsResponseModel>
      getClassrooms() async {

    final response = await ApiClient.dio.get(

      _endpoint,

    );

    return TeacherClassroomsResponseModel.fromJson(

      response.data,

    );

  }

  //----------------------------------------------------------
  // RAFRAICHIR
  //----------------------------------------------------------

  Future<TeacherClassroomsResponseModel>
      refresh() {

    return getClassrooms();

  }

}