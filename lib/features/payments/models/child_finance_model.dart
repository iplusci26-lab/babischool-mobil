
import 'payment_model.dart';

class ChildFinanceModel {
  final String id;
  final String name;
  final String school;
  final String classroom;
  final double tuitionFee;
  final double amountPaid;
  final double balance;
  final List<PaymentModel> payments;

  ChildFinanceModel({
    required this.id,
    required this.name,
    required this.school,
    required this.classroom,
    required this.tuitionFee,
    required this.amountPaid,
    required this.balance,
    required this.payments,
  });

  factory ChildFinanceModel.fromJson(Map<String, dynamic> json) {
    double parseAmount(dynamic value) {
      return double.tryParse(value?.toString() ?? '0') ?? 0;
    }

    return ChildFinanceModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      school: json['school']?.toString() ?? '',
      classroom: json['classroom']?.toString() ?? '',
      tuitionFee: parseAmount(json['tuition_fee']),
      amountPaid: parseAmount(json['amount_paid']),
      balance: parseAmount(json['balance']),
      payments: (json['payments'] as List? ?? [])
          .map(
            (e) => PaymentModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  }
}
