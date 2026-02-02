import 'package:flutter/material.dart';

class PublicationCard extends StatelessWidget {
  final String title;
  final String date;
  final String? coverUrl;

  const PublicationCard({
    super.key,
    required this.title,
    required this.date,
    this.coverUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // ================= COVER =================
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 56,
              height: 72,
              child: coverUrl != null
                  ? Image.network(
                      coverUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return _pdfFallback();
                      },
                    )
                  : _pdfFallback(),
            ),
          ),

          const SizedBox(width: 12),

          // ================= TEXT =================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pdfFallback() {
    return Container(
      color: Colors.red.shade50,
      child: const Icon(
        Icons.picture_as_pdf,
        color: Colors.red,
        size: 28,
      ),
    );
  }
}
