import 'package:flutter/material.dart';
import 'dart:ui'; // Tambahkan untuk ImageFilter (blur)
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

  final TextEditingController _searchController = TextEditingController();
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _futureSubjects = StatisticApiService.getSubjects();
    _futureTables = StatisticApiService.getAllTables();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _keyword = '';
    });
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
                  title: const Text(
                    'Tabel Statistik',
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

            // 🔍 SEARCH BAR DENGAN SHADOW DAN GRADIEN
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12), // Padding lebih luas
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
                  onChanged: (value) {
                    setState(() {
                      _keyword = value.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari Judul Tabel Statistik',
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

            Expanded(
              child: _keyword.isEmpty
                  ? _buildSubjectList()
                  : _buildTableSearchResult(),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  // SUBJECT LIST (MODE NORMAL) DENGAN SHADOW DAN GRADIEN
  // ===============================
  Widget _buildSubjectList() {
    return FutureBuilder<List<StatisticSubject>>(
      future: _futureSubjects,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)), // Warna biru BPS
            ),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Gagal memuat subjek',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        final subjects = snapshot.data ?? [];

        if (subjects.isEmpty) {
          return const Center(
            child: Text(
              'Data kosong',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20), // Padding lebih luas
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];

            return AnimatedOpacity(
              opacity: 1.0, // Fade-in sederhana; bisa diperbaiki dengan AnimationController
              duration: const Duration(milliseconds: 500),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16), // Spacing lebih besar
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFF8F8F8)], // Gradien halus pada card
                  ),
                  borderRadius: BorderRadius.circular(20), // Rounded ekstrem
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ExpansionTileTheme(
                  data: ExpansionTileThemeData(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    childrenPadding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 12,
                    ),
                    expandedAlignment: Alignment.centerLeft,
                    iconColor: const Color(0xFF007AFF),
                    collapsedIconColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: ExpansionTile(
                    leading: Icon(
                      _iconForSubject(subject.name ?? ''), // Ikon futuristik
                      color: const Color(0xFF007AFF),
                    ),
                    title: Text(
                      subject.name ?? '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    children: [_buildSubsubjectList(subject.id!)],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ===============================
  // GLOBAL TABLE SEARCH RESULT DENGAN SHADOW
  // ===============================
  Widget _buildTableSearchResult() {
    return FutureBuilder<List<StatisticTable>>(
      future: _futureTables,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Gagal memuat tabel',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        final tables = snapshot.data ?? [];

        final filtered = tables.where((table) {
          final title = table.title?.toLowerCase() ?? '';
          return title.contains(_keyword);
        }).toList();

        if (filtered.isEmpty) {
          return const Center(
            child: Text(
              'Tabel tidak ditemukan',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20), // Padding lebih luas
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.transparent), // Separator transparan untuk kesan clean
          itemBuilder: (context, index) {
            final table = filtered[index];

            return AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16), // Rounded untuk futuristik
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  title: _highlight(table.title ?? '-', _keyword),
                  subtitle: Text(
                    '${table.subjectName ?? ''} • ${table.subsubjectName ?? ''}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(
                    Icons.table_chart_outlined,
                    color: Color(0xFF007AFF),
                  ),
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
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSubsubjectList(int subjectId) {
    return FutureBuilder<List<StatisticSubsubject>>(
      future: StatisticApiService.getSubsubjects(subjectId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Gagal memuat subjek turunan',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Tidak ada subjek turunan',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          );
        }

        return Column(
          children: items.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50, // Background halus untuk subitem
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  item.name ?? '-',
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF007AFF),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StatisticTableListScreen(
                        subsubjectId: item.id!,
                        title: item.name ?? '',
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  IconData _iconForSubject(String name) {
    final n = name.toLowerCase();
    if (n.contains('demografi')) return Icons.people_alt_outlined;
    if (n.contains('ekonomi')) return Icons.trending_up_outlined;
    if (n.contains('sosial')) return Icons.groups_outlined;
    if (n.contains('pertanian')) return Icons.agriculture_outlined;
    return Icons.insert_chart_outlined;
  }

  Widget _highlight(String text, String keyword) {
    if (keyword.isEmpty) return Text(text);
    final lower = text.toLowerCase();
    final k = keyword.toLowerCase();
    final i = lower.indexOf(k);
    if (i < 0) return Text(text);

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16), // Font size konsisten
        children: [
          TextSpan(text: text.substring(0, i)),
          TextSpan(
            text: text.substring(i, i + k.length),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF007AFF), // Highlight dengan warna biru
            ),
          ),
          TextSpan(text: text.substring(i + k.length)),
        ],
      ),
    );
  }
}