import 'package:flutter/material.dart';
import '../../models/news.dart';
import '../../core/helpers/download_helper.dart';
import '../../core/config/api_config.dart';
import 'package:share_plus/share_plus.dart';

class NewsDetailScreen extends StatelessWidget {
  final News news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // Background iOS-like
      appBar: AppBar(
        title: const Text(
          'Berita Resmi Statistik',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF007AFF),
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF007AFF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCover(),
            _buildHeader(),
            // _buildInfoCards(),
            _buildAbstract(),
            const SizedBox(height: 120), // Ruang untuk bottom bar
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          16,
          20,
          28,
        ), // Padding lebih luas
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.ios_share,
                color: Color(0xFF007AFF),
                size: 28,
              ),
              onPressed: () {
                final title = news.title;
                final date = news.releaseDate;

                final text = date != null && date.isNotEmpty
                    ? '$title\n\nDirilis: $date'
                    : title;

                Share.share(text);
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: const Color(0xFF007AFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      20,
                    ), // Rounded lebih besar
                  ),
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
                onPressed: () {
                  DownloadHelper.downloadPublicationPdf(
                    context: context,
                    publicationId: news.id,
                    fileName: '${news.title.replaceAll(' ', '_')}.pdf',
                  );
                },
                child: const Text(
                  'Unduh',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCover() {
    return Container(
      height: 240,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24), // Rounded lebih besar
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        image: news.imageUrl != null
            ? DecorationImage(
                image: NetworkImage(
                  '${news.imageUrl}',
                ),
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              news.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24, // Sedikit lebih besar
                fontWeight: FontWeight.bold,
                // color: Color(0xFF007AFF),
              ),
            ),
            const SizedBox(height: 12),
            if (news.releaseDate != null)
              Text(
                'Dirilis pada tanggal ${news.releaseDate}',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  // Widget _buildInfoCards() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Row(
  //       children: [
  //         _infoCard(
  //           icon: Icons.inventory_2,
  //           title: 'Nomor\nKatalog',
  //           value: publication.catalogNumber?.toString() ?? '-',
  //         ),
  //         _infoCard(
  //           icon: Icons.menu_book,
  //           title: 'Nomor\nPublikasi',
  //           value: publication.publicationNumber ?? '-',
  //         ),
  //         _infoCard(
  //           icon: Icons.qr_code_2_outlined,
  //           title: 'ISSN /\nISBN',
  //           value: publication.isbn ?? '-',
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 12,
        ), // Padding lebih luas
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // Rounded lebih besar
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF007AFF),
              size: 28, // Icon lebih besar
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                // color: Color(0xFF007AFF),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbstract() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Abstraksi',
            style: TextStyle(
              fontSize: 20, // Sedikit lebih besar
              fontWeight: FontWeight.bold,
              // color: Color(0xFF007AFF),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              news.summary ?? 'Tidak ada abstraksi.',
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
