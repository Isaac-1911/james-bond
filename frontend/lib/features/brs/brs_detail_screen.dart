import 'package:flutter/material.dart';
import 'package:frontend/core/services/api_service.dart';
import 'package:frontend/models/news.dart';

class BrsDetailScreen extends StatefulWidget {
  final int brsId;

  const BrsDetailScreen({
    super.key,
    required this.brsId,
  });

  @override
  State<BrsDetailScreen> createState() => _BrsDetailScreenState();
}

class _BrsDetailScreenState extends State<BrsDetailScreen> {
  late Future<News> _futureNews;

  @override
  void initState() {
    super.initState();
    _futureNews = ApiService().getNewsById(widget.brsId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text('Berita Resmi Statistik'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<News>(
        future: _futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text(
                'Gagal memuat detail BRS',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final news = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== IMAGE =====
                if (news.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      news.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 16),

                // ===== TITLE =====
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                // ===== RELEASE DATE =====
                if (news.releaseDate != null)
                  Text(
                    'Dirilis: ${news.releaseDate}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),

                const SizedBox(height: 16),

                // ===== SUMMARY =====
                if (news.summary != null)
                  Text(
                    news.summary!,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
