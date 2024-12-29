import 'package:flutter/material.dart';

void showFabMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (context) {
      return Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Rapor Yaz'),
            onTap: () {
              Navigator.pop(context); // Menü kapatılır.
              Navigator.pushNamed(context, '/write_report');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Tüm Raporlar'),
            onTap: () {
              Navigator.pop(context); // Menü kapatılır.
              Navigator.pushNamed(context, '/all_reports');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Kılavuzlar'),
            onTap: () {
              Navigator.pop(context); // Menü kapatılır.
              Navigator.pushNamed(context, '/referances');
            },
          ),
        ],
      );
    },
  );
}
