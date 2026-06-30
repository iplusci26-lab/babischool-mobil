import '../models/finance_summary_model.dart';

import '../../../core/api/api_client.dart';

class PaymentService {

  Future<FinanceSummaryModel>
  getFinanceSummary() async {

    final response =
        await ApiClient.dio.get(
      "/mobile/payments/",
    );
    print("reponse----- $response.data");
    return FinanceSummaryModel
        .fromJson(
      response.data,
    );
  }

  Future<void> changeActiveChild(
  String childId,
) async {

  await ApiClient.dio.post(

    "/mobile/active-child/",

    data: {

      "student_id":
      childId,
    },
  );
}

Future<FinanceSummaryModel>
getStudentFinanceSummary(
    String studentId,
) async {

    final response =

        await ApiClient.dio.get(

      "/mobile/students/$studentId/finance/",
    );

    return FinanceSummaryModel.fromJson(
      response.data,
    );
}
}