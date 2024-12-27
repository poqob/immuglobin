import 'dart:async';

import 'package:dio/dio.dart';
import 'package:immuglobin/model/doctor.dart';
import 'package:immuglobin/model/patience.dart';
import 'package:immuglobin/model/user.dart';

// login function
FutureOr<User?> authenticate(String email, String password) async {
  final dio = Dio();
  try {
    final response = await dio.post('http://127.0.0.1:5000/authenticate',
        data: {'email': email, 'password': password});
    if (response.data == null) {
      return null;
    }
    if (response.data['role']['role'] == 'doctor') {
      return Doctor.fromJson(response.data);
    } else if (response.data['role']['role'] == 'patient' ||
        response.data['role']['role'] == 'patience') {
      return Patience.fromJson(response.data);
    } else {
      return User.fromJson(response.data);
    }
  } catch (e) {
    if (e is DioException) {
      print('Error: ${e.response?.statusCode} ${e.response?.statusMessage}');
      print('Data: ${e.response?.data}');
    } else {
      print(e);
    }
    rethrow;
  }
}

// register
Future<void> register(User user) async {
  final dio = Dio();
  try {
    final response =
        await dio.post('http://127.0.0.1:5000/register', data: user.toJson());
    print(response.data);
  } catch (e) {
    if (e is DioException) {
      print('Error: ${e.response?.statusCode} ${e.response?.statusMessage}');
      print('Data: ${e.response?.data}');
    } else {
      print(e);
    }
  }
}

// authorization
Future<void> authorize(User user, action) async {
  final dio = Dio();
  try {
    final response = await dio.post('http://127.0.0.1:5000/authorize', data: {
      'email': user.email,
      'password': user.password,
      "permissions": action
    });
    print(response.data);
  } catch (e) {
    if (e is DioException) {
      print('Error: ${e.response?.statusCode} ${e.response?.statusMessage}');
      print('Data: ${e.response?.data}');
    }
  }
}

FutureOr<Map<String, dynamic>> update_password(
    String email, String password, String newPassword) async {
  final dio = Dio();

  try {
    final authUser = await authenticate(email, password);
    if (authUser == null) return {'error': 'Wrong email or password.'};

    final response = await dio.post('http://127.0.0.1:5000/change_password',
        data: {
          'email': email,
          'old_password': password,
          'new_password': newPassword
        });
    return response.data;
  } catch (e) {
    if (e is DioException) {
      print('Error: ${e.response?.statusCode} ${e.response?.statusMessage}');
      print('Data: ${e.response?.data}');
    }
    rethrow;
  }
}

Future<void> fetchData() async {
  final dio = Dio();
  try {
    final response = await dio.get('http://127.0.0.1:5000/users');
    print(response.data);
  } catch (e) {
    print(e);
  }
}

FutureOr<Map<String, dynamic>> delete_user(
    String email, String password) async {
  final dio = Dio();
  try {
    final response = await dio.post('http://127.0.0.1:5000/remove',
        data: {'email': email, 'password': password});
    return response.data;
  } catch (e) {
    rethrow;
  }
}
