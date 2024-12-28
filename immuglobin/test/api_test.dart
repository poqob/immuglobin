import 'dart:async';
import 'package:immuglobin/api/auth_service.dart';
import 'package:immuglobin/model/doctor.dart';
import 'package:immuglobin/model/patience.dart';
import 'package:immuglobin/model/role.dart';

final joe = Doctor(
    id: 1,
    name: 'John Doe',
    email: 'john.doe@email.com',
    password: 'newpassword123',
    domains: ['cardiology', 'surgery'],
    role: Role("doctor", ["create", "read", "update", "delete"]),
    gender: true,
    bornDate: "01/01/2000",
    bornPlace: "nothing");

final helga = Patience(
    id: 2,
    name: "Helga Bam",
    email: "helga@gmail.com",
    password: "password123",
    role: Role("patient", ["read", "update"]),
    gender: false,
    bornDate: "12/06/2003",
    bornPlace: "Agora",
    patience_type: "urgent");

Future<void> addDumpUser(AuthService authServ) async {
  await authServ.register(joe);
  await authServ.register(helga);
}

Future<void> main() async {
  AuthService authService = AuthService();

  final user = await authService.authenticate(helga.email, helga.password);
  await authService.authorize(user!, user.role.permissions);
}
