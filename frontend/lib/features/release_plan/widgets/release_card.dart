import 'package:flutter/material.dart';
import 'package:frontend/features/news/news_detail_screen.dart';
import 'package:frontend/models/release_plan.dart';
import 'package:frontend/features/publication/publication_detail_screen.dart';
import 'package:frontend/features/brs/brs_detail_screen.dart';
import 'package:frontend/core/services/api_service.dart';

class ReleaseCard extends StatelessWidget {
  final ReleasePlan item;

  const ReleaseCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${item.plannedDate.day} ${_month(item.plannedDate.month)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF007AFF),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxWidth < 360;

              if (isSmallScreen) {
                // 🔽 LAYAR KECIL → tombol di bawah teks status
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.isReleased
                          ? 'Sudah rilis (${_fmt(item.releasedDate!)})'
                          : 'Belum rilis',
                      style: TextStyle(
                        color: item.isReleased ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: _actionButton(context, item),
                    ),
                  ],
                );
              }

              // ➡️ LAYAR NORMAL / BESAR → sejajar
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.isReleased
                        ? 'Sudah rilis (${_fmt(item.releasedDate!)})'
                        : 'Belum rilis',
                    style: TextStyle(
                      color: item.isReleased ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  _actionButton(context, item),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _month(int m) => [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ][m - 1];

  String _fmt(DateTime d) => '${d.day} ${_month(d.month)} ${d.year}';

  void _openTarget(BuildContext context, ReleasePlan item) async {
    if (!item.isReleased || item.targetId == null) return;

    try {
      if (item.type == 'publikasi') {
        final publication = await ApiService().getPublicationById(
          item.targetId!,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PublicationDetailScreen(publication: publication),
          ),
        );
      } else if (item.type == 'brs') {
        final news = await ApiService().getNewsById(
          item.targetId!,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsDetailScreen(news: news),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal membuka detail'),
          backgroundColor: Color(0xFF007AFF),
        ),
      );
    }
  }

  Widget _actionButton(BuildContext context, ReleasePlan item) {
    return ElevatedButton(
      onPressed: item.isReleased && item.targetId != null
          ? () => _openTarget(context, item)
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007AFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1, // iOS-like
      ),
      child: Text(
        item.type == 'brs' ? 'Lihat BRS' : 'Lihat Publikasi',
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
