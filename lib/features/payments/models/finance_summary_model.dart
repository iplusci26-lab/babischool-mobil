
import 'child_finance_model.dart';
import 'payment_model.dart';

class FinanceSummaryModel {
  final String studentName;
  final double tuitionFee;
  final double amountPaid;
  final double balance;
  final String studentId;
  final List<PaymentModel> payments;
  final List<ChildFinanceModel> children;

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
    Map<String, dynamic> json,
  ) {
    double parseAmount(dynamic value) {
      return double.tryParse(value?.toString() ?? '0') ?? 0;
    }

    // Format 1 : réponse avec plusieurs enfants
    final childrenList = (json['children'] as List? ?? [])
        .map(
          (e) => ChildFinanceModel.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();

    if (childrenList.isNotEmpty) {
      final firstChild = childrenList.first;

      return FinanceSummaryModel(
        studentName: firstChild.name,
        studentId: firstChild.id,
        tuitionFee: firstChild.tuitionFee,
        amountPaid: firstChild.amountPaid,
        balance: firstChild.balance,
        payments: firstChild.payments,
        children: childrenList,
      );
    }

    // Format 2 : réponse pour un seul enfant
    final student = json['student'] is Map
        ? Map<String, dynamic>.from(json['student'])
        : <String, dynamic>{};

    final paymentsList = (json['payments'] as List? ?? [])
        .map(
          (e) => PaymentModel.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();

    return FinanceSummaryModel(
      studentName: student['name']?.toString() ?? '',
      studentId: student['id']?.toString() ?? '',
      tuitionFee: parseAmount(json['tuition_fee']),
      amountPaid: parseAmount(json['amount_paid']),
      balance: parseAmount(json['balance']),
      payments: paymentsList,
      children: [],
    );
  }

  FinanceSummaryModel forChild(String childId) {
    // Si le modèle contient directement les données de l'enfant
    if (children.isEmpty) {
      return this;
    }

    final selectedChild = children.firstWhere(
      (child) => child.id == childId,
      orElse: () => children.first,
    );

    return FinanceSummaryModel(
      studentName: selectedChild.name,
      studentId: selectedChild.id,
      tuitionFee: selectedChild.tuitionFee,
      amountPaid: selectedChild.amountPaid,
      balance: selectedChild.balance,
      payments: selectedChild.payments,
      children: children,
    );
  }
}
