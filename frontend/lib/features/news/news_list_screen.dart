import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/news.dart';
import '../../core/services/api_service.dart';
import 'news_detail_screen.dart';
import 'widgets/news_card.dart';
import 'widgets/news_card_shimmer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ValueNotifier<bool> _isSearching = ValueNotifier<bool>(false);
  Timer? _debounceTimer;

  List<News> _news = [];
  bool _isLoading = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _fetchNews();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _isSearching.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    final query = _searchController.text.trim();
    if (query.isEmpty) {
      _query = '';
      _isSearching.value = false;
      _fetchNews();
      return;
    }

    _isSearching.value = true;
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _query = query;
      _fetchNews();
      _isSearching.value = false;
    });
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
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onSearchSubmit(String value) {
    _searchFocusNode.unfocus();
    _query = value.trim();
    _fetchNews();
  }

  void _clearSearch() {
    _searchController.clear();
    _query = '';
    _fetchNews();
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 20),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // GestureDetector(
            //   onTap: () => Navigator.pop(context),
            //   child: Container(
            //     width: 44,
            //     height: 44,
            //     decoration: BoxDecoration(
            //       color: Colors.grey.shade100,
            //       shape: BoxShape.circle,
            //     ),
            //     child: const Icon(
            //       Icons.arrow_back_rounded,
            //       color: Color(0xFF007AFF),
            //       size: 22,
            //     ),
            //   ),
            // ),
            const Text(
              'Berita Resmi Statistik',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D1D1F),
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.article_rounded,
                color: Color(0xFF007AFF),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          textInputAction: TextInputAction.search,
          onSubmitted: _onSearchSubmit,
          decoration: InputDecoration(
            hintText: 'Cari berita statistik...',
            hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
            prefixIcon: Container(
              margin: const EdgeInsets.only(left: 16, right: 12),
              child: const Icon(
                Icons.search_rounded,
                color: Color(0xFF007AFF),
                size: 22,
              ),
            ),
            suffixIcon: ValueListenableBuilder<bool>(
              valueListenable: _isSearching,
              builder: (context, isSearching, child) {
                if (isSearching) {
                  return Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF007AFF),
                    ),
                  );
                }
                return _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: _clearSearch,
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF007AFF), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _news.isEmpty) {
      return _buildLoadingShimmer();
    }

    if (_news.isEmpty && !_isLoading) {
      return _buildEmptyState();
    }

    return _buildNewsList();
  }

  Widget _buildLoadingShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        itemCount: 6,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => const NewsCardShimmer(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.article_outlined,
              color: Color(0xFF007AFF),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Berita tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _query.isEmpty
                ? 'Tidak ada berita tersedia'
                : 'Tidak ada berita dengan kata kunci "$_query"',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          if (_query.isNotEmpty) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              height: 44,
              child: ElevatedButton(
                onPressed: _clearSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Hapus Pencarian',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF007AFF),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${_news.length} berita ditemukan${_query.isNotEmpty ? ' untuk "$_query"' : ''}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF007AFF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: _news.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = _news[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewsDetailScreen(news: item),
                      ),
                    );
                  },
                  child: NewsCard(
                    title: item.title,
                    date: item.releaseDate ?? '',
                    coverUrl: item.imageUrl ?? '',
                  ).animate().fadeIn(duration: 300.ms, delay: (index * 60).ms),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
