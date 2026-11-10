
class StaffStudentModel {
  final String id;
  final String studentId;
  final String studentNumber;
  final String firstName;
  final String lastName;
  final String fullName;
  final String gender;
  final String? dateOfBirth;
  final String classroom;

  const StaffStudentModel({
    required this.id,
    required this.studentId,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.gender,
    this.dateOfBirth,
    required this.classroom,
  });

  factory StaffStudentModel.fromJson(Map<String, dynamic> json) {
    return StaffStudentModel(
      id: (json['id'] ?? '').toString(),
      studentId: (json['student_id'] ?? '').toString(),
      studentNumber: (json['student_number'] ?? '').toString(),
      firstName: (json['first_name'] ?? '').toString(),
      lastName: (json['last_name'] ?? '').toString(),
      fullName: (json['full_name'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      classroom: (json['classroom'] ?? '').toString(),
    );
  }
}
