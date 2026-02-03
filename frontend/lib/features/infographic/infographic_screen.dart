import 'package:flutter/material.dart';
import '../../core/config/api_config.dart';

class InfographicScreen extends StatelessWidget {
  const InfographicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Infografis',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          InfographicCard(
            title: 'Data Pemotongan Ternak Sapi 2024',
            imageUrl: 'infographics/sapi_2024.png',
            description:
                'Infografis ini menyajikan data jumlah pemotongan ternak sapi di Kabupaten Bondowoso tahun 2024 berdasarkan triwulan dan bulan.',
          ),
          SizedBox(height: 24),
          InfographicCard(
            title: 'Produksi Padi Kabupaten Bondowoso',
            imageUrl: 'infographics/sapi_lagi.png',
            description:
                'Infografis ini menyajikan data jumlah pemotongan ternak sapi di Kabupaten Bondowoso tahun 2024 berdasarkan triwulan dan bulan.',
          ),
        ],
      ),
    );
  }
}

class InfographicCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;

  const InfographicCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            _actionButton(
              icon: Icons.download_outlined,
              label: 'Unduh',
              onTap: () {},
            ),
            const SizedBox(width: 16),
            _actionButton(
              icon: Icons.share_outlined,
              label: 'Bagikan',
              onTap: () {},
            ),
          ],
        ),

        const SizedBox(height: 12),

        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
