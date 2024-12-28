import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG desteği için

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uygulama Hakkında'),
        backgroundColor: const Color.fromARGB(255, 205, 209, 238),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SVG Görsel Alanı
            SvgPicture.asset(
              'assets/info.svg', // Bilgilendirme SVG görselinizin yolu
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 30),
            // Bilgilendirme Metni
            const Text(
              'Bu uygulama, kullanıcıların ihtiyaçlarını en iyi şekilde karşılamak amacıyla geliştirilmiştir. '
              'Geliştirici ekibimiz, sizin için en iyi deneyimi sunmayı hedefliyor.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),
            // Ana Sayfa Düğmesi
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 205, 209, 238),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Ana sayfaya dön
              },
              child: const Text(
                'Ana Sayfa',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
