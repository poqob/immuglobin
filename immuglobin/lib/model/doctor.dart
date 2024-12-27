// doctor.dart
import 'package:immuglobin/model/role.dart';
import 'package:immuglobin/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Doctor extends User {
  final List<String>? domains;

  Doctor({
    required super.id,
    required super.name,
    required super.email,
    required super.password,
    required super.role,
    required super.gender,
    required super.bornDate,
    required super.bornPlace,
    this.domains,
  });
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: Role.fromJson(json['role'] as Map<String, dynamic>),
      gender: json['gender'] as bool,
      bornDate: json['born_date'],
      bornPlace: json['born_place'] as String,
      domains:
          (json['domains'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );
  }

  @override
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
      'domains': domains,
    };
  }
}
