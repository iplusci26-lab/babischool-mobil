class StaffStudentParentModel {
  final String firstName;
  final String lastName;
  final String fullName;
  final String phone;
  final String? alternatePhone;
  final String? occupation;
  final String? address;
  final String? gender;
  final String relationshipType;
  final String relationshipTypeDisplay;
  final bool isPrimaryContact;
  final bool receivesNotifications;

  StaffStudentParentModel({
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.phone,
    this.alternatePhone,
    this.occupation,
    this.address,
    this.gender,
    required this.relationshipType,
    required this.relationshipTypeDisplay,
    required this.isPrimaryContact,
    required this.receivesNotifications,
  });

  factory StaffStudentParentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StaffStudentParentModel(
      firstName: (json['first_name'] ?? '').toString(),
      lastName: (json['last_name'] ?? '').toString(),
      fullName: (json['full_name'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      alternatePhone: json['alternate_phone']?.toString(),
      occupation: json['occupation']?.toString(),
      address: json['address']?.toString(),
      gender: json['gender']?.toString(),
      relationshipType: (json['relationship_type'] ?? '').toString(),
      relationshipTypeDisplay:
          (json['relationship_type_display'] ?? '').toString(),
      isPrimaryContact: json['is_primary_contact'] == true,
      receivesNotifications: json['receives_notifications'] == true,
    );
  }
}

class StaffStudentDetailModel {
  final String id;
  final String studentNumber;
  final String firstName;
  final String lastName;
  final String fullName;
  final String gender;
  final String? dateOfBirth;
  final String? birthPlace;
  final String? admissionDate;
  final bool isAssigned;
  final bool isRepeating;
  final String classroomId;
  final String classroom;
  final String classroomLevel;
  final String cycle;
  final String academicYear;
  final bool isActive;
  final String status;
  final double tuitionFee;
  final double amountPaid;
  final double balance;
  final List<StaffStudentParentModel> parents;

  StaffStudentDetailModel({
    required this.id,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.gender,
    this.dateOfBirth,
    this.birthPlace,
    this.admissionDate,
    required this.isAssigned,
    required this.isRepeating,
    required this.classroomId,
    required this.classroom,
    required this.classroomLevel,
    required this.cycle,
    required this.academicYear,
    required this.isActive,
    required this.status,
    required this.tuitionFee,
    required this.amountPaid,
    required this.balance,
    required this.parents,
  });

  static double _parseAmount(dynamic value) {
  if (value == null) return 0.0;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0.0;
}

  factory StaffStudentDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final parentsJson = json['parents'] as List<dynamic>? ?? [];

    return StaffStudentDetailModel(
      id: (json['id'] ?? '').toString(),
      studentNumber: (json['student_number'] ?? '').toString(),
      firstName: (json['first_name'] ?? '').toString(),
      lastName: (json['last_name'] ?? '').toString(),
      fullName: (json['full_name'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      birthPlace: json['birth_place']?.toString(),
      admissionDate: json['admission_date']?.toString(),
      isAssigned: json['is_assigned'] == true,
      isRepeating: json['is_repeating'] == true,
      classroomId: (json['classroom_id'] ?? '').toString(),
      classroom: (json['classroom'] ?? '').toString(),
      classroomLevel: (json['classroom_level'] ?? '').toString(),
      cycle: (json['cycle'] ?? '').toString(),
      academicYear: (json['academic_year'] ?? '').toString(),
      isActive: json['is_active'] == true,
      status: (json['status'] ?? '').toString(),

      tuitionFee: _parseAmount(json['tuition_fee']),
      amountPaid: _parseAmount(json['amount_paid']),
      balance: _parseAmount(json['balance']),

      parents: parentsJson
          .map(
            (parent) => StaffStudentParentModel.fromJson(
              parent as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }
}