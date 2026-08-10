class TeacherClassroomModel {

  final String id;

  final String name;

  const TeacherClassroomModel({

    required this.id,

    required this.name,

  });

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  factory TeacherClassroomModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return TeacherClassroomModel(

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

  TeacherClassroomModel copyWith({

    String? id,

    String? name,

  }) {

    return TeacherClassroomModel(

      id: id ?? this.id,

      name: name ?? this.name,

    );

  }

  //----------------------------------------------------------
  // HELPERS
  //----------------------------------------------------------

  String get displayName => name;

  //----------------------------------------------------------
  // TOSTRING
  //----------------------------------------------------------

  @override
  String toString() {

    return "TeacherClassroomModel("
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

    return other is TeacherClassroomModel &&
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