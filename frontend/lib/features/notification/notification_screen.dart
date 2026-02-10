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
            date: '27 Agustus 2025',
            title: 'Rilis Versi 2.0.1 Telah Hadir!',
            sections: [
              NotificationSection(
                title: '✨ Fitur Baru',
                items: [
                  'Akses sumber data berupa tabel pada indikator strategis kini lebih mudah dan cepat.',
                  'Akses data ekspor-impor kini tersedia, memungkinkan pengguna menjelajahi informasi perdagangan internasional berdasarkan HS Code, negara, pelabuhan, tahun, dan bulan.',
                ],
              ),
              NotificationSection(
                title: '💥 Perbaikan & Peningkatan',
                items: [
                  'Perbaikan bug minor guna meningkatkan stabilitas aplikasi.',
                  'Optimalisasi performa agar pengalaman penggunaan lebih lancar.',
                ],
              ),
            ],
          ),

          NotificationCard(
            date: '24 November 2020',
            title: 'Rilis Versi Baru',
            sections: [
              NotificationSection(
                title: 'Penambahan Fitur',
                items: [
                  'Publikasi terbaru, populer, dan utama',
                  'BRS terbaru, populer, dan utama',
                  'Tabel berdasarkan subyek, baru, dan populer',
                  'ARC Berita Resmi Statistik',
                  'SDGs',
                  'Menu Tentang Kami',
                  'Info Layanan',
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
