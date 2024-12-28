// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:immuglobin/core/constants/session.dart';
import 'package:immuglobin/features/settings/view/email_change_screen.dart';
import 'package:immuglobin/features/settings/view/password_change_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? role;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = Session.getUser();
    setState(() {
      role = userData?.role.role;
    });
  }

  void _navigateToPasswordChange() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordChangeScreen()),
    );
  }

  void _navigateToEmailChange() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EmailChangeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToPasswordChange,
              child: const Text('Şifre Değiştir'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToEmailChange,
              child: const Text('Mail Değiştir'),
            ),
          ],
        ),
      ),
    );
  }
}
