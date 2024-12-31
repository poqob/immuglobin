// ignore_for_file: avoid_print

import 'dart:ffi';

import 'package:immuglobin/api/api_service.dart';
import 'package:immuglobin/model/user.dart';

class UserService {
  final ApiService api;

  UserService() : api = ApiService();

  Future<void> fetchData() async {
    final response = await api.get('/users');
    print(response.data);
  }

  Future<Map<String, dynamic>> deleteUser(String email, String password) async {
    final response =
        await api.post('/remove', {'email': email, 'password': password});
    return response.data;
  }

  Future<Map<String, dynamic>> getUserById(String id) async {
    final int parsedId = int.parse(id);
    final response = await api.post('/get_user_by_id', {'id': parsedId});
    return response.data;
  }
}

Future<void> main() async {
  final UserService userService = UserService();
  User user = User.fromJson(await userService.getUserById('11111111111'));
  print(user);
}
