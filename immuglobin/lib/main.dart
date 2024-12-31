import 'package:flutter/material.dart';
import 'package:immuglobin/features/appinfo/view/appinfo_screen.dart';
import 'package:immuglobin/features/dump/view/dump_screen.dart';
import 'package:immuglobin/features/hello/view/hello_screen.dart';
import 'package:immuglobin/features/home/view/home_screen.dart';
import 'package:immuglobin/features/login/view/login_screen.dart';
import 'package:immuglobin/features/referance/view/add_referance_screen.dart';
import 'package:immuglobin/features/referance/view/query_referance.dart';
import 'package:immuglobin/features/referance/view/referance_screen.dart';
import 'package:immuglobin/features/register/view/register_screen.dart';
import 'package:immuglobin/features/report/view/all_reports_screen.dart';
import 'package:immuglobin/features/report/view/my_reports_screen.dart';
import 'package:immuglobin/features/report/view/write_report_screen.dart';
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
      title: 'Megali İdea',
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
        '/home': (context) => HomeScreen(),
        '/appinfo': (context) => const AppInfoScreen(),
        '/referances': (context) => const ReferenceScreen(),
        '/all_reports': (context) => const AllReportScreen(),
        '/write_report': (context) => const WriteReportScreen(),
        '/my_reports': (context) => const MyReportsScreen(),
        '/add_referance': (context) => const AddReferanceScreen(),
        '/query_referance': (context) => const QueryReferanceScreen(),
      },
    );
  }
}
