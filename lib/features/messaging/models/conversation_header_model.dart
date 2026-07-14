class ConversationHeaderModel {

  final ContactModel contact;

  final StudentHeaderModel student;

  const ConversationHeaderModel({

    required this.contact,

    required this.student,

  });

  factory ConversationHeaderModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return ConversationHeaderModel(

      contact: ContactModel.fromJson(

        json["contact"] ?? {},

      ),

      student: StudentHeaderModel.fromJson(

        json["student"] ?? {},

      ),

    );

  }

}

////////////////////////////////////////////////////////
///
/// CONTACT
///
////////////////////////////////////////////////////////

class ContactModel {

  final String id;

  final String name;

  final String role;

  final String? avatar;

  const ContactModel({

    required this.id,

    required this.name,

    required this.role,

    this.avatar,

  });

  factory ContactModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return ContactModel(

      id: json["id"] ?? "",

      name: json["name"] ?? "",

      role: json["role"] ?? "",

      avatar: json["avatar"],

    );

  }

}

////////////////////////////////////////////////////////
///
/// ELEVE
///
////////////////////////////////////////////////////////

class StudentHeaderModel {

  final String id;

  final String name;

  final String classroom;

  const StudentHeaderModel({

    required this.id,

    required this.name,

    required this.classroom,

  });

  factory StudentHeaderModel.fromJson(

    Map<String, dynamic> json,

  ) {

    return StudentHeaderModel(

      id: json["id"] ?? "",

      name: json["name"] ?? "",

      classroom: json["classroom"] ?? "",

    );

  }

}