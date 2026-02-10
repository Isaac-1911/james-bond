import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  int? _selectedYear;
  int _segmentIndex = 0;
  final ApiService _apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ValueNotifier<bool> _isSearching = ValueNotifier<bool>(false);
  Timer? _debounceTimer;

  final List<Publication> _publications = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;
  final int _limit = 12;
  String _query = '';
  // String? _sort;

  @override
  void initState() {
    super.initState();
    _fetchPublications();
    _searchController.addListener(_onSearchChanged);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !_isLoading &&
          _hasMore) {
        _fetchPublications();
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
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
      _resetAndFetch();
      return;
    }

    _isSearching.value = true;
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      _query = query;
      _resetAndFetch();
      _isSearching.value = false;
    });
  }

  void _resetAndFetch() {
    if (!mounted) return;

    setState(() {
      _page = 1;
      _hasMore = true;
      _publications.clear();
    });

    _fetchPublications();
  }

  Future<void> _fetchPublications() async {
    if (_isLoading || !_hasMore) return;

    try {
      if (!mounted) return;

      setState(() => _isLoading = true);
      final result = await _apiService.getPublications(
        page: _page,
        limit: _limit,
        query: _query.isEmpty ? null : _query,
        sort: _segmentIndex == 1 ? 'popular' : null,
        category: null,
        year: _selectedYear,
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
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onSearchSubmit(String value) {
    _searchFocusNode.unfocus();
    _query = value.trim();
    _resetAndFetch();
  }

  void _clearSearch() {
    _searchController.clear();
    _query = '';
    _resetAndFetch();
    _searchFocusNode.unfocus();
  }

  void _onSegmentChanged(int index) {
    if (_segmentIndex == index) return;

    setState(() {
      _segmentIndex = index;
      // _sort = index == 1 ? 'popular' : null;
    });

    _resetAndFetch();
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
            _buildSearchSection(),
            const SizedBox(height: 20),
            _buildSegment(),
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
              'Publikasi',
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
                Icons.book_rounded,
                color: Color(0xFF007AFF),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
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
                hintText: 'Cari publikasi...',
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
                  borderSide: const BorderSide(
                    color: Color(0xFF007AFF),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                _openFilterSheet();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF007AFF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFF007AFF), width: 1.5),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tune_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Filter & Urutkan',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle drag indicator
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Filter Pencarian',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D1D1F),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                color: Color(0xFF6E6E73),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Saring hasil berdasarkan kriteria tertentu',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Filter Item: Tahun Rilis
                      GestureDetector(
                        onTap: _openYearPicker,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF007AFF,
                                  ).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.calendar_month_rounded,
                                  color: Color(0xFF007AFF),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tahun Rilis',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1D1D1F),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _selectedYear?.toString() ??
                                          'Semua Tahun',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: _selectedYear != null
                                            ? const Color(0xFF007AFF)
                                            : Colors.grey.shade600,
                                        fontWeight: _selectedYear != null
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.grey.shade400,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _resetFilter();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF007AFF),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: const BorderSide(
                                      color: Color(0xFF007AFF),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _applyFilter();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF007AFF),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Terapkan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _resetFilter() {
    setState(() {
      _selectedYear = null;
      _page = 1;
      _hasMore = true;
      _publications.clear();
    });

    _fetchPublications();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF34C759),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: const Row(
          children: [
            Icon(Icons.restart_alt_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Filter berhasil direset',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _openYearPicker() {
    final currentYear = DateTime.now().year;
    final years = List.generate(
      20,
      (i) => currentYear - i,
    ); // 20 tahun ke belakang

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pilih Tahun',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D1D1F),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Color(0xFF6E6E73),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Pilih tahun rilis publikasi',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 16),

                // "Semua Tahun" option
                GestureDetector(
                  onTap: () {
                    setState(() => _selectedYear = null);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: _selectedYear == null
                          ? const Color(0xFF007AFF).withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedYear == null
                            ? const Color(0xFF007AFF)
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedYear == null
                                  ? const Color(0xFF007AFF)
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: _selectedYear == null
                              ? Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF007AFF),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Semua Tahun',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1D1D1F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Year list with divider
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Divider(color: Color(0xFFE5E5EA), thickness: 1),
                ),

                const SizedBox(height: 8),

                // Years list
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: years.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Color(0xFFF2F2F7),
                      indent: 20,
                      endIndent: 20,
                    ),
                    itemBuilder: (context, index) {
                      final year = years[index];
                      final isSelected = _selectedYear == year;

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() => _selectedYear = year);
                          Navigator.pop(context);
                        },
                        child: Container(
                          color: isSelected
                              ? const Color(0xFF007AFF).withValues(alpha: 0.05)
                              : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF007AFF)
                                        : Colors.grey.shade400,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? Center(
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF007AFF),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                year.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFF007AFF)
                                      : const Color(0xFF1D1D1F),
                                ),
                              ),
                              const Spacer(),
                              if (isSelected)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF007AFF,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Terpilih',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: const Color(0xFF007AFF),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Close button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        foregroundColor: const Color(0xFF6E6E73),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _applyFilter() {
    _page = 1;
    _hasMore = true;
    _publications.clear();
    _fetchPublications();
  }

  Widget _buildSegment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: _segmentIndex == 0
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width / 2 - 24,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF007AFF).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                _buildSegmentItem('Semua', 0),
                _buildSegmentItem('Populer', 1),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentItem(String label, int index) {
    final isActive = _segmentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onSegmentChanged(index),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFF6E6E73),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _publications.isEmpty) {
      return _buildLoadingShimmer();
    }

    if (_publications.isEmpty && !_isLoading) {
      return _buildEmptyState();
    }

    return _buildPublicationsList();
  }

  Widget _buildLoadingShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        itemCount: 6,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => const PublicationCardShimmer(),
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
              Icons.book_rounded,
              color: Color(0xFF007AFF),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Publikasi tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _query.isEmpty
                ? 'Tidak ada publikasi tersedia'
                : 'Tidak ada publikasi dengan kata kunci "$_query"',
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

  Widget _buildPublicationsList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
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
                    '${_publications.length} publikasi ditemukan${_query.isNotEmpty ? ' untuk "$_query"' : ''}',
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
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.separated(
              controller: _scrollController,
              itemCount: _publications.length + (_hasMore ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (index == _publications.length) {
                  return _buildLoadMoreIndicator();
                }

                final publication = _publications[index];
                return _buildPublicationItem(publication, index);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: _hasMore
            ? const CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF007AFF),
              )
            : Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Semua publikasi telah ditampilkan',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ),
      ),
    );
  }

  Widget _buildPublicationItem(Publication publication, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PublicationDetailScreen(publication: publication),
          ),
        );
      },
      child: PublicationCard(
        title: publication.title,
        date: publication.releaseDate ?? '',
        coverUrl: publication.coverUrl != null
            ? '${ApiConfig.storageUrl}/${publication.coverUrl}'
            : null,
      ).animate().fadeIn(duration: 300.ms, delay: (index * 60).ms),
    );
  }
}
