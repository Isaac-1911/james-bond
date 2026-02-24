import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'widgets/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // iOS background
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF007AFF),
          ),
        ),
        backgroundColor: Colors.white.withValues(alpha: 0.9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Color(0xFF007AFF)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          NotificationCard(
            date: '21 Februari 2025',
            title: 'James Bond Data Portal Resmi Hadir di Play Store!',
            sections: [
              NotificationSection(
                title: '🚀 Fitur Unggulan',
                items: [
                  'Akses publikasi resmi dengan tampilan modern dan navigasi yang cepat.',
                  'Jelajahi tabel statistik dinamis berdasarkan subject dan subsubject.',
                  'Unduh publikasi dalam format PDF langsung dari aplikasi.',
                  'Pencarian global untuk menemukan data, publikasi, dan berita secara instan.',
                  'Infografis interaktif untuk memahami data secara visual.',
                ],
              ),
              NotificationSection(
                title: '📊 Modul Statistik Dinamis',
                items: [
                  'Struktur tabel fleksibel dengan jumlah kolom dan baris yang dinamis.',
                  'Data terintegrasi langsung dengan backend resmi.',
                  'Export data ke CSV dan Excel untuk kebutuhan analisis lanjutan.',
                ],
              ),
              NotificationSection(
                title: '⚡ Performa & Stabilitas',
                items: [
                  'Optimasi performa untuk pengalaman yang lebih lancar.',
                  'Arsitektur backend–frontend terpisah untuk keamanan dan skalabilitas.',
                  'Dikembangkan dengan standar production-ready untuk stabilitas jangka panjang.',
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
