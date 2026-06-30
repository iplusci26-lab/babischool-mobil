class ParentModel {

  final String id;

  final String firstName;

  final String lastName;

  final String phone;

  ParentModel({

    required this.id,

    required this.firstName,

    required this.lastName,

    required this.phone,
  });

  factory ParentModel.fromJson(
    Map<String,dynamic> json,
  ) {

    return ParentModel(

      id: json["id"],

      firstName:
      json["first_name"],

      lastName:
      json["last_name"],

      phone:
      json["phone"],
    );
  }
}