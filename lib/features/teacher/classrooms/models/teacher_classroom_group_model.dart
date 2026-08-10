class TeacherClassroomGroupModel {

  final String id;

  final String name;

  const TeacherClassroomGroupModel({

    required this.id,

    required this.name,

  });

  //----------------------------------------------------------
  // JSON
  //----------------------------------------------------------

  factory TeacherClassroomGroupModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return TeacherClassroomGroupModel(

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

  TeacherClassroomGroupModel copyWith({

    String? id,

    String? name,

  }) {

    return TeacherClassroomGroupModel(

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

    return "TeacherClassroomGroupModel("
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

    return other is TeacherClassroomGroupModel &&
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