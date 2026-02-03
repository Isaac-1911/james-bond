import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend/models/category.dart';
import '../../models/publication.dart';
import '../../core/config/api_config.dart';
import '../publication/widgets/publication_card.dart';
import '../../core/services/api_service.dart';
import '../publication/publication_detail_screen.dart';
import '../publication/widgets/publication_card_shimmer.dart';

class PublicationListScreen extends StatefulWidget {
  const PublicationListScreen({super.key});

  @override
  State<PublicationListScreen> createState() => _PublicationListScreenState();
}

class _PublicationListScreenState extends State<PublicationListScreen> {
  int _segmentIndex = 0;

  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Publication> _publications = [];
  bool _isLoading = false;
  bool _hasMore = true;

  int _page = 1;
  final int _limit = 10;
  String _query = '';
  String? _sort;
  int? _category;
  int? _utamaCategoryId;

  @override
  void initState() {
    super.initState();
    _fetchPublications();
    _loadCategories();
    debugPrint('🔥 PublicationListScreen initState CALLED');

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _fetchPublications();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _apiService.getCategories();

      final utama = categories.firstWhere(
        (c) => c.name?.toLowerCase() == 'utama',
        orElse: () => Category(id: -1, name: ''),
      );

      if (utama.id != -1) {
        _utamaCategoryId = utama.id;
      }
    } catch (_) {
      // fail silently
    }
  }

  Future<void> _fetchPublications() async {
    if (_isLoading || !_hasMore) {
      return;
    }

    try {
      if (!mounted) return;

      setState(() => _isLoading = true);
      final result = await _apiService.getPublications(
        page: _page,
        limit: _limit,
        query: _query.isEmpty ? null : _query,
        sort: _sort,
        category: _category,
      );
      final List<Publication> newItems = result['items'];
      final int currentPage = result['currentPage'];
      final int lastPage = result['lastPage'];

      if (!mounted) return;

      setState(() {
        _publications.addAll(newItems);
        _page++;
        _hasMore = currentPage < lastPage;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('❌ FETCH ERROR: $e');
      debugPrint('$stackTrace');

      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onSearchSubmit(String value) {
    _query = value.trim();
    _page = 1;
    _hasMore = true;
    _publications.clear();
    _fetchPublications();
  }

  void _clearSearch() {
    _searchController.clear();
    _query = '';
    _page = 1;
    _hasMore = true;
    _publications.clear();
    _fetchPublications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background gradien futuristik (dari putih ke abu-abu halus)
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
            // ===== APPBAR DENGAN EFEK BLUR DAN GRADIEN (FUTURISTIK) =====
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Efek blur glassmorphism
                child: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text(
                    'Publikasi',
                    style: TextStyle(
                      fontSize: 22, // Sedikit lebih besar untuk kesan modern
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF007AFF),
                    ),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.8), // Transparan untuk blur
                  elevation: 0,
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white, Color(0xFFE0E0E0)], // Gradien halus
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.place, size: 20, color: Colors.grey), // Ikon sedikit lebih besar
                      SizedBox(width: 8),
                      Text(
                        'BPS Kabupaten Bondowoso',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4), // Shadow futuristik
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: _onSearchSubmit,
                            decoration: InputDecoration(
                              hintText: 'Cari Publikasi di sini',
                              prefixIcon: const Icon(Icons.search, color: Color(0xFF007AFF)),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close, color: Colors.grey),
                                      onPressed: _clearSearch,
                                    )
                                  : null,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24), // Lebih rounded untuk futuristik
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF007AFF), Color(0xFF0056CC)], // Gradien biru futuristik
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF007AFF).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.tune, color: Colors.white),
                          label: const Text('Filter', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // Transparan untuk gradien
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSegment(),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (_isLoading && _publications.isEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: 6,
                      itemBuilder: (_, __) => const PublicationCardShimmer(),
                    );
                  }

                  if (_publications.isEmpty) {
                    return const Center(
                      child: Text(
                        'Publikasi tidak ditemukan',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _publications.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _publications.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
                              ),
                            ),
                          ),
                        );
                      }

                      final publication = _publications[index];

                      return AnimatedOpacity(
                        opacity: 1.0, // Fade-in sederhana; bisa diperbaiki dengan AnimationController
                        duration: const Duration(milliseconds: 500),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PublicationDetailScreen(
                                  publication: publication,
                                ),
                              ),
                            );
                          },
                          child: PublicationCard(
                            title: publication.title,
                            date: publication.releaseDate ?? '',
                            coverUrl: publication.coverUrl != null
                                ? '${ApiConfig.storageUrl}/${publication.coverUrl}'
                                : null,
                          ),
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

  Alignment _segmentAlignment() {
    if (_segmentIndex == 0) return Alignment.centerLeft;
    if (_segmentIndex == 1) return Alignment.center;
    return Alignment.centerRight;
  }

  double _segmentWidth() {
    return MediaQuery.of(context).size.width / 3;
  }

  Widget _buildSegment() {
    return Container(
      height: 48, // Sedikit lebih tinggi untuk kesan premium
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5EA),
        borderRadius: BorderRadius.circular(24), // Lebih rounded
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final segmentWidth = constraints.maxWidth / 3;

              return AnimatedAlign(
                duration: const Duration(milliseconds: 300), // Lebih smooth
                curve: Curves.easeInOut,
                alignment: _segmentAlignment(),
                child: Container(
                  width: segmentWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF007AFF), Color(0xFF0056CC)], // Gradien pada indicator
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF007AFF).withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Row(
            children: [
              _segmentItem('Semua', 0),
              _segmentItem('Populer', 1),
              _segmentItem('Utama', 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _segmentItem(String label, int index) {
    final bool isActive = _segmentIndex == index;
    final bool isDisabled = label == 'Utama' && _utamaCategoryId == null;

    return Expanded(
      child: GestureDetector(
        onTap: isDisabled
            ? null
            : () {
                setState(() {
                  _segmentIndex = index;
                  _page = 1;
                  _hasMore = true;
                  _publications.clear();

                  if (index == 0) {
                    _sort = null;
                    _category = null;
                  } else if (index == 1) {
                    _sort = 'popular';
                    _category = null;
                  } else if (index == 2) {
                    _sort = null;
                    _category = _utamaCategoryId;
                  }
                });
                _fetchPublications();
              },
        child: Opacity(
          opacity: isDisabled ? 0.4 : 1,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15, // Sedikit lebih besar
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}