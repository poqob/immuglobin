class Role {
  final String role;
  final List<String> permissions;

  Role(this.role, this.permissions);

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      json['role'] as String,
      (json['permissions'] as List).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'permissions': permissions,
    };
  }
}
