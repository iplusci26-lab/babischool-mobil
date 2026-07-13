import 'child_finance_model.dart';
import 'payment_model.dart';
class FinanceSummaryModel {

  final String studentName;

  final double tuitionFee;

  final double amountPaid;

  final double balance;

  final String studentId;

  final List<PaymentModel> payments;

  final List<ChildFinanceModel>children;

  FinanceSummaryModel({
    required this.studentName,
    required this.tuitionFee,
    required this.amountPaid,
    required this.balance,
    required this.payments,
    required this.children,
    required this.studentId,
  });

  factory FinanceSummaryModel.fromJson(
    Map<String,dynamic> json,
  ) {

    return FinanceSummaryModel(

      studentName:
      json["student"]?["name"] ?? "",

      studentId:
      json["student"]["id"],

      tuitionFee:
      double.parse(
        json["tuition_fee"]
            .toString(),
      ),

      amountPaid:
      double.parse(
        json["amount_paid"]
            .toString(),
      ),

      balance:
      double.parse(
        json["balance"]
            .toString(),
      ),

      payments:
      (json["payments"] as List)

      .map(
        (e) =>
        PaymentModel.fromJson(e),
      )

      .toList(),

      children: (json["children"] as List? ?? [])

      .map(

        (e) => ChildFinanceModel.fromJson(e),

      )

      .toList(),
      );
  }
}