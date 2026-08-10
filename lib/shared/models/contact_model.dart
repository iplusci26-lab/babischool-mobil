class ContactModel {
  final String name;
  final String role;
  final String? avatar;

  const ContactModel({
    required this.name,
    required this.role,
    this.avatar,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      name: json["name"] ?? "",
      role: json["role"] ?? "",
      avatar: json["avatar"],
    );
  }
}