import 'package:flutter/material.dart';
import 'package:immuglobin/features/dump/view/dump_screen.dart';
import 'package:immuglobin/features/hello/view/hello_screen.dart';
import 'package:immuglobin/features/login/view/login_screen.dart';
import 'package:immuglobin/features/register/view/register_screen.dart';
import 'package:immuglobin/features/settings/view/settings_screen.dart';
import 'package:immuglobin/features/splash/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/dump': (context) => const DumpScreen(),
        '/hello': (context) => const HelloScreen(),
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
