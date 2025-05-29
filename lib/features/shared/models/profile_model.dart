class Profile {
  final String id;
  final String name;
  final int role;
  final String email;
  final String userName;
  final String password;

  Profile({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.userName,
    required this.password,
  });

  /// Creates a [Profile] from a JSON map.
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['_id'].toString(),
      name: json['name'],
      role: json['role'],
      email: json['email'],
      userName: json['userName'],
      password: json['password'],
    );
  }

  /// Converts this [Profile] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'role': role,
      'email': email,
      'userName': userName,
      'password': password,
    };
  }
}
