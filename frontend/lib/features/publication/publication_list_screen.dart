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
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        automaticallyImplyLeading: false, // ⬅️ KUNCI
        title: const Text(
          'Publikasi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF007AFF),
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
      ),
      body: Column(
        children: [
          // ===== HEADER SEARCH =====
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              children: [
                Row(
                  children: const [
                    Icon(Icons.place, size: 18, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      'BPS Republik Indonesia',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onSubmitted: _onSearchSubmit,
                        decoration: InputDecoration(
                          hintText: 'Cari Publikasi di sini',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: _clearSearch,
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.tune),
                      label: const Text('Filter'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ===== SEGMENT =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildSegment(),
          ),

          const SizedBox(height: 20),

          // ===== LIST =====
          Expanded(
            child: Builder(
              builder: (context) {
                // ===== SHIMMER (FIRST LOAD) =====
                if (_isLoading && _publications.isEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 6,
                    itemBuilder: (_, __) => const PublicationCardShimmer(),
                  );
                }

                // ===== EMPTY STATE =====
                if (_publications.isEmpty) {
                  return const Center(
                    child: Text(
                      'Publikasi tidak ditemukan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                // ===== NORMAL LIST + PAGINATION =====
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
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }

                    final publication = _publications[index];

                    return GestureDetector(
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
                    );
                  },
                );
              },
            ),
          ),
        ],
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

  Widget _segmentButton(String label, int index) {
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
                    // Semua
                    _sort = null;
                    _category = null;
                  } else if (index == 1) {
                    // Populer
                    _sort = 'popular';
                    _category = null;
                  } else if (index == 2) {
                    // Utama
                    _sort = null;
                    _category = _utamaCategoryId;
                  }
                });

                _fetchPublications();
              },
        child: Opacity(
          opacity: isDisabled ? 0.4 : 1,
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF007AFF) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegment() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5EA),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          // ===== SLIDING INDICATOR =====
          LayoutBuilder(
            builder: (context, constraints) {
              final segmentWidth = constraints.maxWidth / 3;

              return AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                alignment: _segmentAlignment(),
                child: Container(
                  width: segmentWidth, // ✅ FIX
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              );
            },
          ),

          // ===== BUTTONS =====
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
                fontSize: 14,
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
