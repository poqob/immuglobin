import 'package:immuglobin/api/api_service.dart';
import 'package:immuglobin/core/constants/session.dart';
import 'package:immuglobin/model/user.dart';
import 'package:immuglobin/model/doctor.dart';
import 'package:immuglobin/model/patience.dart';

class AuthService {
  final ApiService api;
  AuthService() : api = ApiService();

  Future<User?> authenticate(String email, String password) async {
    final response =
        await api.post('/authenticate', {'email': email, 'password': password});
    final data = response.data;
    if (data == null) return null;

    final role = data['role']['role'];
    if (role == 'doctor') {
      Doctor doctor = Doctor.fromJson(data);
      await saveUserData(doctor);
      return doctor;
    } else if (role == 'patient' || role == 'patience') {
      Patience patience = Patience.fromJson(data);
      await saveUserData(patience);
      return patience;
    } else {
      User user = User.fromJson(data);
      await saveUserData(user);
      return user;
    }
  }

  Future<Map<String, dynamic>> register(User user) async {
    final response = await api.post('/register', user.toJson());
    return response.data;
  }

  Future<Map<String, dynamic>> authorize(User user, List<String> action) async {
    final response = await api.post('/authorize', {
      'email': user.email,
      'password': user.password,
      'permissions': action,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> updatePassword(
      String email, String password, String newPassword) async {
    final authUser = await authenticate(email, password);
    if (authUser == null) return {'error': 'Wrong email or password.'};

    final response = await api.post('/change_password', {
      'email': email,
      'old_password': password,
      'new_password': newPassword,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> updateEMail(
      String email, String password, String newEmail) async {
    final authUser = await authenticate(email, password);
    if (authUser == null) return {'error': 'Wrong email or password.'};

    final response = await api.post('/change_email', {
      'old_email': email,
      'password': password,
      'new_email': newEmail,
    });
    return response.data;
  }

  Future<void> saveUserData(User user) async {
    Session.setUser(user);
  }
}
