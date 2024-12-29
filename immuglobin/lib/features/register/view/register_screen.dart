// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:immuglobin/api/auth_service.dart';
import 'package:immuglobin/model/doctor.dart'; // Import Doctor model
import 'package:immuglobin/model/patience.dart'; // Import Patience model
import 'package:immuglobin/model/role.dart';
import 'package:immuglobin/model/user.dart'; // User model
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart'; // For date formatting

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final authApi = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _bornDateController = TextEditingController();
  final _bornPlaceController = TextEditingController();
  final _domainsController = TextEditingController();

  String _selectedRole = 'patient'; // Default role
  String _selectedGender = 'male'; // Default gender
  String _selectedPatienceType = 'regular'; // Default patient type
  DateTime? _bornDate; // To store selected birth date
  bool _isLoading = false;

  // Function to show date picker and select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _bornDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _bornDate) {
      setState(() {
        _bornDate = picked;
        _bornDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Create a User object based on selected role
      User user;

      if (_selectedRole == 'doctor') {
        user = Doctor(
          id: _idController.text.isNotEmpty ? int.parse(_idController.text) : 0,
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          role: Role(_selectedRole, ['update', 'create', 'read', 'delete']),
          gender: _selectedGender == 'male', // Gender from the form
          bornDate: _bornDateController.text, // Date from the form
          bornPlace: _bornPlaceController.text, // Born place from the form
          domains: _domainsController.text
              .split(','), // Comma-separated list of domains
        );
      } else {
        user = Patience(
          id: _idController.text.isNotEmpty ? int.parse(_idController.text) : 0,
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          role: Role(_selectedRole, ['update', 'read']),
          gender: _selectedGender == 'male', // Gender from the form
          bornDate: _bornDateController.text, // Date from the form
          bornPlace: _bornPlaceController.text, // Born place from the form
          patience_type: _selectedPatienceType, // Patient type from the form
        );
      }

      try {
        final response = await authApi.register(user);

        if (response['status'] == 'success') {
          // On successful registration, navigate to hello screen
          Navigator.pushReplacementNamed(context, '/hello');
        } else {
          // If registration failed, show error message
          Fluttertoast.showToast(
              msg: 'Registration failed: ${response['message']}');
        }
      } catch (e) {
        // Handle errors and show toast
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
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: form(context),
        ),
      ),
    );
  }

  Form form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _idController,
            decoration: InputDecoration(labelText: 'ID'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'ID is required';
              } else if (int.tryParse(value) == null) {
                return 'ID must be a number';
              } else if (int.parse(value) < 0) {
                return 'ID must be a positive number';
              } else if (value.length != 11) {
                return 'ID must be 11 digits';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              } else if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                  .hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirm Password is required';
              } else if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          DropdownButtonFormField<String>(
            value: _selectedRole,
            onChanged: (newValue) {
              setState(() {
                _selectedRole = newValue!;
              });
            },
            items: ['patient', 'doctor']
                .map((role) => DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    ))
                .toList(),
            decoration: InputDecoration(labelText: 'Role'),
          ),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            onChanged: (newValue) {
              setState(() {
                _selectedGender = newValue!;
              });
            },
            items: ['male', 'female']
                .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    ))
                .toList(),
            decoration: InputDecoration(labelText: 'Gender'),
          ),
          TextFormField(
            controller: _bornDateController,
            decoration: InputDecoration(labelText: 'Born Date'),
            onTap: () => _selectDate(context), // Open date picker
            readOnly: true, // Prevent typing manually
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Born date is required';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _bornPlaceController,
            decoration: InputDecoration(labelText: 'Born Place'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Born place is required';
              }
              return null;
            },
          ),
          if (_selectedRole == 'doctor')
            TextFormField(
              controller: _domainsController,
              decoration:
                  InputDecoration(labelText: 'Domains (comma separated)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please specify at least one domain';
                }
                return null;
              },
            ),
          if (_selectedRole ==
              'patient') // Show patient type only if role is 'patient'
            DropdownButtonFormField<String>(
              value: _selectedPatienceType,
              onChanged: (newValue) {
                setState(() {
                  _selectedPatienceType = newValue!;
                });
              },
              items: ['regular', 'VIP', 'special']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              decoration: InputDecoration(labelText: 'Patient Type'),
            ),
          SizedBox(height: 20),
          _isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _submit,
                  child: Text('Register'),
                ),
        ],
      ),
    );
  }
}
