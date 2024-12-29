import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG desteği için
import 'package:immuglobin/core/constants/session.dart';
import 'package:immuglobin/features/home/widgets/drawer.dart';
import 'package:immuglobin/features/home/widgets/floating_action.dart';
import 'package:immuglobin/model/user.dart';

class HomeScreen extends StatelessWidget {
  final User user = Session.getUser() as User;
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
      ),
      drawer: drawer(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Yuvarlak Çerçeve İçinde SVG Görsel
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              child: SvgPicture.asset(
                user.role.role == 'doctor'
                    ? 'assets/doctor.svg'
                    : 'assets/patient.svg', // SVG dosyasının yolu
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            // Kullanıcı Bilgileri
            Text(
              'Hoş geldin, ${user.name}!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'E-posta: ${user.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Doğum Tarihi: ${user.bornDate}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Doğum Yeri: ${user.bornPlace}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: Session.getUser()?.role.role == 'doctor'
          ? FloatingActionButton(
              onPressed: () {
                showFabMenu(context);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
