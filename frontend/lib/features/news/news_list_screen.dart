import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/news.dart';
import '../../core/config/api_config.dart';
import '../../core/services/api_service.dart';
import 'news_detail_screen.dart';
import 'widgets/news_card.dart';
import 'widgets/news_card_shimmer.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<News> _news = [];
  bool _isLoading = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchNews() async {
    try {
      if (!mounted) return;

      setState(() => _isLoading = true);

      final items = await _apiService.getNews(
        query: _query.isEmpty ? null : _query,
      );

      if (!mounted) return;

      setState(() {
        _news = items;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('❌ FETCH NEWS ERROR: $e');
      debugPrint('$stackTrace');

      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onSearchSubmit(String value) {
    _query = value.trim();
    _fetchNews();
  }

  void _clearSearch() {
    _searchController.clear();
    _query = '';
    _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF2F2F7), Color(0xFFE5E5EA)],
          ),
        ),
        child: Column(
          children: [
            // ===== APPBAR GLASSMORPHISM =====
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AppBar(
                  automaticallyImplyLeading: false,
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
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Color(0xFFE0E0E0)],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ===== SEARCH BAR =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: _onSearchSubmit,
                        decoration: InputDecoration(
                          hintText: 'Cari Berita Statistik',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF007AFF),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close, color: Colors.grey),
                                  onPressed: _clearSearch,
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ===== CONTENT =====
            Expanded(
              child: Builder(
                builder: (context) {
                  if (_isLoading && _news.isEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: 6,
                      itemBuilder: (_, __) => const NewsCardShimmer(),
                    );
                  }

                  if (_news.isEmpty) {
                    return const Center(
                      child: Text(
                        'Berita tidak ditemukan',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _news.length,
                    itemBuilder: (context, index) {
                      final item = _news[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewsDetailScreen(
                                news: item,
                              ),
                            ),
                          );
                        },
                        child: NewsCard(
                          title: item.title,
                          date: item.releaseDate ?? '',
                          coverUrl: item.imageUrl!
                        ),
                      );  
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
