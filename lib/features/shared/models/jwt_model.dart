class JWTPayload {
  final String id;
  final String name;
  final int role;

  JWTPayload({
    required this.id,
    required this.name,
    required this.role,
  });

  factory JWTPayload.fromJson(Map<String, dynamic> json) {
    return JWTPayload(
      id: json['_id'],
      name: json['name'],
      role: json['role'],
    );
  }
}