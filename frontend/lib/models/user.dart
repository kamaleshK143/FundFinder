class AppUser {
  final int id;
  final String fullName;
  final String email;
  final String role;

  AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      role: json['role'],
    );
  }
}
