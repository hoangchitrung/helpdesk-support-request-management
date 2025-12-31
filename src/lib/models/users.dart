class Users {
  String userId;
  String username;
  String email;
  String role;

  Users({
    required this.userId,
    required this.username,
    required this.email,
    required this.role,
  });

  factory Users.fromMap(Map<String, dynamic> data, String userId) {
    return Users(
      userId: userId,
      username: data['username'],
      email: data['email'],
      role: data['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'username': username, 'email': email, 'role': role};
  }
}
