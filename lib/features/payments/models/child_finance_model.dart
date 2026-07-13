class ChildFinanceModel {

  final String id;

  final String name;

  final String classroom;

  final double balance;

  

  ChildFinanceModel({

    required this.id,

    required this.name,

    required this.classroom,

    required this.balance,
  });

  factory ChildFinanceModel.fromJson(
    Map<String,dynamic> json,
  ) {

    return ChildFinanceModel(

      id:
      json["id"],

      name:
      json["name"],

      classroom:
      json["classroom"],

      balance:
      double.parse(
        json["balance"]
            .toString(),
      ),
    );
  }
}