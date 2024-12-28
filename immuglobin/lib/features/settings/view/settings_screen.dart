import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:immuglobin/api/auth_service.dart'; // Updated import for the new AuthService

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();
  bool _isLoading = false;
  final authApi = AuthService(); // Updated to use new AuthService

  String? email;
  String? password;
  String? role;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data when the screen is initialized
  }

  Future<void> _loadUserData() async {
    final userData =
        await authApi.getUserData(); // Fetch user data from SharedPreferences
    setState(() {
      email = userData['email']; // Set the email from the saved data
      password = userData['password']; // Set the password from the saved data
      role = userData['role']['role'];
    });
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (email == null || password == null) {
          Fluttertoast.showToast(msg: 'User data is not loaded yet.');
          return;
        }

        // Use AuthService to update the password
        final result = await authApi.updatePassword(
          email!,
          _passwordController.text,
          _newPasswordController.text,
        );

        if (result['error'] != null) {
          Fluttertoast.showToast(msg: result['error']);
        } else {
          Fluttertoast.showToast(msg: 'Password changed successfully.');
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'An error occurred: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (email == null || password == null)
                Center(
                    child:
                        CircularProgressIndicator()) // Show loading spinner until user data is loaded
              else ...[
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Current Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Current password is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(labelText: 'New Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'New password is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmNewPasswordController,
                  decoration:
                      InputDecoration(labelText: 'Confirm New Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm the new password';
                    } else if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _changePassword,
                        child: Text('Change Password'),
                      ),
                SizedBox(height: 20),
                if (role == 'doctor')
                  Text(
                    'Doctor Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                if (role == 'patient')
                  Text(
                    'Patient Settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
