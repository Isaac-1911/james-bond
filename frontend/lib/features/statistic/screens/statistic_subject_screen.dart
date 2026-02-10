import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/services/statistic_api_service.dart';
import '../../../models/statistic_subject.dart';
import '../../../models/statistic_subsubject.dart';
import '../../../models/statistic_table.dart';
import 'statistic_table_screen.dart';
import 'statistic_table_list_screen.dart';

class StatisticSubjectScreen extends StatefulWidget {
  const StatisticSubjectScreen({super.key});

  @override
  State<StatisticSubjectScreen> createState() => _StatisticSubjectScreenState();
}

class _StatisticSubjectScreenState extends State<StatisticSubjectScreen> {
  late final Future<List<StatisticSubject>> _futureSubjects;
  late final Future<List<StatisticTable>> _futureTables;
  final StatisticApiService _statisticApi = StatisticApiService();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ValueNotifier<String> _searchKeyword = ValueNotifier<String>('');
  final ValueNotifier<bool> _isSearching = ValueNotifier<bool>(false);
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _futureSubjects = _statisticApi.getSubjects();
    _futureTables = _statisticApi.getAllTables();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchKeyword.dispose();
    _isSearching.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    final query = _searchController.text.trim();
    if (query.isEmpty) {
      _searchKeyword.value = '';
      _isSearching.value = false;
      return;
    }

    _isSearching.value = true;
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _searchKeyword.value = query.toLowerCase();
      _isSearching.value = false;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchKeyword.value = '';
    _isSearching.value = false;
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
            _buildSearchBar(),
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: _searchKeyword,
                builder: (context, keyword, child) {
                  return keyword.isEmpty
                      ? _buildSubjectList()
                      : _buildTableSearchResult();
                },
              ),
            ),
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
              'Tabel Statistik',
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
                Icons.table_chart_rounded,
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
      padding: const EdgeInsets.all(20),
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
          onSubmitted: (value) {
            _searchKeyword.value = value.trim().toLowerCase();
            _searchFocusNode.unfocus();
          },
          decoration: InputDecoration(
            hintText: 'Cari judul tabel statistik...',
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

  Widget _buildSubjectList() {
    return FutureBuilder<List<StatisticSubject>>(
      future: _futureSubjects,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState('Memuat subjek statistik...');
        }

        if (snapshot.hasError) {
          return _buildErrorState(
            'Gagal memuat subjek',
            'Coba lagi nanti',
            () => setState(() {}),
          );
        }

        final subjects = snapshot.data ?? [];

        if (subjects.isEmpty) {
          return _buildEmptyState(
            'Belum ada subjek',
            'Data subjek belum tersedia',
          );
        }

        return _buildSubjectsContent(subjects);
      },
    );
  }

  Widget _buildSubjectsContent(List<StatisticSubject> subjects) {
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
                  Icons.category_rounded,
                  color: Color(0xFF007AFF),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${subjects.length} subjek statistik',
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
              itemCount: subjects.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) =>
                  _buildSubjectItem(subjects[index], index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectItem(StatisticSubject subject, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(20),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getSubjectColor(subject.name),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getSubjectIcon(subject.name),
              color: Colors.white,
              size: 24,
            ),
          ),
          title: Text(
            subject.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          trailing: const Icon(
            Icons.expand_more_rounded,
            color: Color(0xFF8E8E93),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: _buildSubsubjectList(subject.id!),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: (index * 60).ms);
  }

  Widget _buildSubsubjectList(int subjectId) {
    return FutureBuilder<List<StatisticSubsubject>>(
      future: _statisticApi.getSubsubjects(subjectId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF007AFF),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'Gagal memuat subjek turunan',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'Tidak ada subjek turunan',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
          );
        }

        return Column(
          children: items.map((item) {
            return _buildSubsubjectItem(item);
          }).toList(),
        );
      },
    );
  }

  Widget _buildSubsubjectItem(StatisticSubsubject item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StatisticTableListScreen(
              subsubjectId: item.id!,
              title: item.name,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.table_chart_rounded,
                  color: Color(0xFF007AFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1D1D1F),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF8E8E93),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableSearchResult() {
    return FutureBuilder<List<StatisticTable>>(
      future: _futureTables,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState('Mencari tabel...');
        }

        if (snapshot.hasError) {
          return _buildErrorState(
            'Gagal mencari tabel',
            'Coba lagi nanti',
            () => setState(() {}),
          );
        }

        final tables = snapshot.data ?? [];
        final keyword = _searchKeyword.value;
        final filtered = tables.where((table) {
          final title = table.title?.toLowerCase() ?? '';
          return title.contains(keyword);
        }).toList();

        if (filtered.isEmpty) {
          return _buildEmptyState(
            'Tidak ditemukan',
            'Tidak ada tabel dengan kata kunci "$keyword"',
          );
        }

        return _buildSearchResultsContent(filtered, keyword);
      },
    );
  }

  Widget _buildSearchResultsContent(
    List<StatisticTable> tables,
    String keyword,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF34C759).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF34C759),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${tables.length} tabel ditemukan untuk "$keyword"',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF34C759),
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
              itemCount: tables.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _buildSearchResultItem(tables[index], index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(StatisticTable table, int index) {
    final keyword = _searchKeyword.value;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StatisticTableScreen(
              tableId: table.id!,
              title: table.title ?? '',
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.table_chart_rounded,
                  color: Color(0xFF007AFF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _highlightText(table.title ?? 'Tidak ada judul', keyword),
                    if (table.subjectName != null ||
                        table.subsubjectName != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (table.subjectName != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF34C759,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                table.subjectName!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF34C759),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          if (table.subsubjectName != null) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFF9500,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                table.subsubjectName!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFFF9500),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                    if (table.lastUpdated != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.update_rounded,
                            color: Colors.grey.shade500,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Update: ${_formatDate(table.lastUpdated!)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF8E8E93),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms, delay: (index * 60).ms),
    );
  }

  Widget _highlightText(String text, String keyword) {
    if (keyword.isEmpty) {
      return Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1D1D1F),
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerKeyword = keyword.toLowerCase();
    final matches = <Match>[];
    var start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerKeyword, start);
      if (index == -1) break;
      matches.add(Match(index, index + keyword.length));
      start = index + keyword.length;
    }

    if (matches.isEmpty) {
      return Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1D1D1F),
        ),
      );
    }

    final textSpans = <TextSpan>[];
    var currentIndex = 0;

    for (final match in matches) {
      if (match.start > currentIndex) {
        textSpans.add(
          TextSpan(
            text: text.substring(currentIndex, match.start),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
        );
      }

      textSpans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF007AFF),
            backgroundColor: Color(0xFF007AFF).withValues(alpha: 0.1),
          ),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      textSpans.add(
        TextSpan(
          text: text.substring(currentIndex),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1D1F),
          ),
        ),
      );
    }

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: textSpans),
    );
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF007AFF),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String title, String subtitle, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFFF3B30),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 160,
            height: 44,
            child: ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
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
              Icons.search_off_rounded,
              color: Color(0xFF007AFF),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Color _getSubjectColor(String subjectName) {
    final name = subjectName.toLowerCase();
    if (name.contains('demografi')) return const Color(0xFF007AFF);
    if (name.contains('ekonomi')) return const Color(0xFF34C759);
    if (name.contains('sosial')) return const Color(0xFFFF9500);
    if (name.contains('pertanian')) return const Color(0xFFAF52DE);
    if (name.contains('industri')) return const Color(0xFFFF3B30);
    if (name.contains('perdagangan')) return const Color(0xFF5856D6);
    return const Color(0xFF007AFF);
  }

  IconData _getSubjectIcon(String subjectName) {
    final name = subjectName.toLowerCase();
    if (name.contains('demografi')) return Icons.people_alt_rounded;
    if (name.contains('ekonomi')) return Icons.trending_up_rounded;
    if (name.contains('sosial')) return Icons.groups_rounded;
    if (name.contains('pertanian')) return Icons.agriculture_rounded;
    if (name.contains('industri')) return Icons.factory_rounded;
    if (name.contains('perdagangan')) return Icons.shopping_cart_rounded;
    return Icons.bar_chart_rounded;
  }

  String _formatDate(DateTime date) {
    final months = [
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
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class Match {
  final int start;
  final int end;

  Match(this.start, this.end);
}
