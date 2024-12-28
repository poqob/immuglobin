import 'package:flutter/material.dart';
import 'package:immuglobin/features/settings/view/settings_screen.dart';

class DumpScreen extends StatelessWidget {
  const DumpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dump Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Ayarlar ekranına geçiş
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsScreen(), // userType parametresini ayarlayın
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'This is the dump screen',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
