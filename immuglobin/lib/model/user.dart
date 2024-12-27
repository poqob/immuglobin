import 'package:immuglobin/model/role.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final Role role;
  final bool gender;
  final String bornDate;
  final String bornPlace;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.gender,
    required this.bornDate,
    required this.bornPlace,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: Role.fromJson(json['role'] as Map<String, dynamic>),
      gender: json['gender'] as bool,
      bornDate: json['born_date'],
      bornPlace: json['born_place'] as String,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email,  role: ${role.toJson()}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role.toJson(),
      'gender': gender,
      'born_date': bornDate,
      'born_place': bornPlace,
    };
  }
}
