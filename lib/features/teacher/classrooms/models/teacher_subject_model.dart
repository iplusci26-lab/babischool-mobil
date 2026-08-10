class TeacherSubjectModel {

  final String? id;

  final String name;

  const TeacherSubjectModel({

    this.id,

    required this.name,

  });

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  factory TeacherSubjectModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return TeacherSubjectModel(

      id: json["id"],

      name: json["name"] ?? "",

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

  TeacherSubjectModel copyWith({

    String? id,

    String? name,

  }) {

    return TeacherSubjectModel(

      id: id ?? this.id,

      name: name ?? this.name,

    );

  }

  //----------------------------------------------------------
  // HELPERS
  //----------------------------------------------------------

  bool get isPrimarySubject {

    return id == null;

  }

  //----------------------------------------------------------
  // TOSTRING
  //----------------------------------------------------------

  @override
  String toString() {

    return "TeacherSubjectModel("
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

    return other is TeacherSubjectModel &&
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