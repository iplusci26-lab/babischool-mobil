class TeacherInfoModel {

  final String id;

  final String name;

  const TeacherInfoModel({

    required this.id,

    required this.name,

  });

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  factory TeacherInfoModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return TeacherInfoModel(

      id: json["id"],

      name: json["name"],

    );

  }

  //----------------------------------------------------------
  // TO JSON
  //----------------------------------------------------------

  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "name": name,

    };

  }

  //----------------------------------------------------------
  // COPY WITH
  //----------------------------------------------------------

  TeacherInfoModel copyWith({

    String? id,

    String? name,

  }) {

    return TeacherInfoModel(

      id: id ?? this.id,

      name: name ?? this.name,

    );

  }

  //----------------------------------------------------------
  // TOSTRING
  //----------------------------------------------------------

  @override
  String toString() {

    return "TeacherInfoModel("
        "id: $id, "
        "name: $name)";
  }

  //----------------------------------------------------------
  // EQUALITY
  //----------------------------------------------------------

  @override
  bool operator ==(Object other) {

    if (identical(this, other)) {

      return true;

    }

    return other is TeacherInfoModel &&
        other.id == id &&
        other.name == name;

  }

  @override
  int get hashCode {

    return Object.hash(

      id,

      name,

    );

  }

}