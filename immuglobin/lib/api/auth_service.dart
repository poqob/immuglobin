import 'package:immuglobin/api/api_service.dart';
import 'package:immuglobin/model/user.dart';
import 'package:immuglobin/model/doctor.dart';
import 'package:immuglobin/model/patience.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiService api;

  AuthService() : api = ApiService();

// TODO: save user doesnt work!
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

  Future<void> saveUserData(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', user.id);
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('password', user.password);
    await prefs.setString('born_date', user.bornDate);
    await prefs.setString('born_place', user.bornPlace);
    await prefs.setBool('gender', user.gender);
    await prefs.setString('role', user.role.role);
    await prefs.setStringList('permissions', user.role.permissions);
  }

  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    String? name = prefs.getString('name');
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    String? bornDate = prefs.getString('born_date');
    String? bornPlace = prefs.getString('born_place');
    bool? gender = prefs.getBool('gender');
    String? role = prefs.getString('role');
    List<String>? permissions = prefs.getStringList('permissions');

    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'born_date': bornDate,
      'born_place': bornPlace,
      'gender': gender,
      'role': role,
      'permissions': permissions,
    };
  }

  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('born_date');
    await prefs.remove('born_place');
    await prefs.remove('gender');
    await prefs.remove('role');
    await prefs.remove('permissions');
  }
}
