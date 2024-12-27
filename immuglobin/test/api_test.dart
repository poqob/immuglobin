import 'dart:async';
import 'package:immuglobin/api/db_api.dart';
import 'package:immuglobin/model/doctor.dart';
import 'package:immuglobin/model/patience.dart';
import 'package:immuglobin/model/role.dart';
import 'package:immuglobin/model/user.dart';

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

Future<void> addDumpUser() async {
  await register(joe);
  await register(helga);
}

Future<void> main() async {
  // await addDumpUser();
  // FutureOr<User?> user = await authenticate(joe.email, joe.password);
  // print(user);
  // await register(helga);

  // FutureOr<User?> usere = await authenticate(helga.email, helga.password);
  // print(usere);

  // final response =
  //     await update_password(joe.email, joe.password, 'newpassword123');
  // print(response);

  // print(delete_user(joe.email, joe.password));
  fetchData();
  // print(delete_user(joe.email, joe.password));
}
