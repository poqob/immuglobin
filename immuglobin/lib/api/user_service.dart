// ignore_for_file: avoid_print

import 'package:immuglobin/api/api_service.dart';

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
}
