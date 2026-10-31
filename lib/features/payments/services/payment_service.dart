import '../models/finance_summary_model.dart';

import '../../../core/api/api_client.dart';
import '../../../core/storage/secure_storage_service.dart';

class PaymentService {

  Future<FinanceSummaryModel>
  getFinanceSummary() async {

    final response =
        await ApiClient.dio.get(
      "/mobile/payments/",
    );
    
    return FinanceSummaryModel
        .fromJson(
      response.data,
    );
  }



Future<void> changeActiveChild(String childId) async {
  final response = await ApiClient.dio.post(
    "/mobile/active-child/",
    data: {
      "student_id": childId,
    },
  );

  final data = response.data;

  final accessToken = data["access"];
  final refreshToken = data["refresh"];

  if (accessToken == null || refreshToken == null) {
    throw Exception("Les nouveaux tokens sont absents.");
  }

  await SecureStorageService.saveAccessToken(
    accessToken.toString(),
  );

  await SecureStorageService.saveRefreshToken(
    refreshToken.toString(),
  );

  if (data["active_child"] != null) {
    await SecureStorageService.saveUser({
      ...?await SecureStorageService.getUser(),
      "active_child": data["active_child"],
    });
  }
}


Future<FinanceSummaryModel>
getStudentFinanceSummary(String studentId,) 
async {
    print("Fiance summary $studentId");
    final response =

        await ApiClient.dio.get(

      "/mobile/students/$studentId/finance/",
    );
    print("response $response.data");
    return FinanceSummaryModel.fromJson(
      response.data,
    );
}
}