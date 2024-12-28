// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:immuglobin/api/auth_service.dart';

class EmailChangeScreen extends StatefulWidget {
  const EmailChangeScreen({super.key});

  @override
  _EmailChangeScreenState createState() => _EmailChangeScreenState();
}

class _EmailChangeScreenState extends State<EmailChangeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _newEmailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _changeEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await _authService.updateEMail(
          _oldEmailController.text,
          _passwordController.text,
          _newEmailController.text,
        );

        if (result['error'] != null) {
          Fluttertoast.showToast(msg: result['error']);
        } else {
          Fluttertoast.showToast(msg: 'Mail başarıyla değiştirildi.');
          Navigator.pop(context); // Sayfayı kapatır.
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'Bir hata oluştu: $e');
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
        title: const Text('Mail Değiştir'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _oldEmailController,
                decoration: const InputDecoration(labelText: 'Eski Mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Eski mail gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Şifre gerekli';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newEmailController,
                decoration: const InputDecoration(labelText: 'Yeni Mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yeni mail gerekli';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Geçerli bir mail adresi girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _changeEmail,
                      child: const Text('Mail Değiştir'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
