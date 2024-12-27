// ignore_for_file: unused_element, non_constant_identifier_names, avoid_print

import 'package:immuglobin/model/doctor.dart';
import 'package:immuglobin/model/patience.dart';
import 'package:immuglobin/model/role.dart';

void _role_test() {
  Role role = Role("role", ["permission1", "permission2"]);
  Role rol = Role.fromJson(role.toJson());
  print(rol.toJson());
}

void _user_test() {
  // Usage example
  final doctor = Doctor(
      id: 1,
      name: 'John Doe',
      email: 'john.doe@email.com',
      password: 'password',
      domains: ['cardiology', 'surgery'],
      role: Role("role", ["create", "read", "update", "delete"]),
      gender: true,
      bornDate: "01/01/2000",
      bornPlace: "nothing");

  final doctor2 = Doctor.fromJson(doctor.toJson());
  print(doctor2.toJson());

  final patience = Patience(
      id: 1,
      name: 'John patience',
      email: 'joe_patience@gmail.com',
      password: 'password',
      role: Role("role", ["read", "update"]),
      gender: true,
      bornDate: "01/01/2000",
      bornPlace: "nothing",
      patience_type: "regular");

  final patience2 = Patience.fromJson(patience.toJson());
  print(patience2.toJson());
}

void main() {
  // _role_test();
  _user_test();
}
