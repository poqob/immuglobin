import 'package:flutter/material.dart';
import 'package:immuglobin/core/constants/session.dart';

Drawer drawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text(
            'Uygulama Çekmecesi',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.report),
          title: const Text('Raporlarım'),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/dump',
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('Uygulama Hakkında'),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/appinfo',
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Ayarlar'),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/settings',
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Çıkış Yap'),
          onTap: () {
            Session.clear();
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/hello',
              (Route<dynamic> route) => false,
            );
          },
        ),
      ],
    ),
  );
}
