class PaymentModel {

  final String id;

  final double amount;

  final String paymentDate;

  final String reference;

  final String notes;

  PaymentModel({
    required this.id,
    required this.amount,
    required this.paymentDate,
    required this.reference,
    required this.notes,
  });

  factory PaymentModel.fromJson(
    Map<String,dynamic> json,
  ) {
    return PaymentModel(
      id: json["id"].toString(),
      amount: double.parse(
        json["amount"].toString(),
      ),
      paymentDate:
          json["payment_date"] ?? "",
      reference:
          json["reference"] ?? "",
      notes:
          json["notes"] ?? "",
    );
  }
}