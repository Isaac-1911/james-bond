import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text('Tabel Statistik')),
      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _clearSearch,
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
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
    );
  }

  // ===============================
  // SUBJECT LIST (MODE NORMAL)
  // ===============================
  Widget _buildSubjectList() {
    return FutureBuilder<List<StatisticSubject>>(
      future: _futureSubjects,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Gagal memuat subjek'));
        }

        final subjects = snapshot.data ?? [];

        if (subjects.isEmpty) {
          return const Center(child: Text('Data kosong'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTileTheme(
                data: ExpansionTileThemeData(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                  childrenPadding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: 8,
                  ),
                  expandedAlignment: Alignment.centerLeft,
                  iconColor: Theme.of(context).colorScheme.primary,
                  collapsedIconColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: ExpansionTile(
                  title: Text(
                    subject.name ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  children: [_buildSubsubjectList(subject.id!)],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ===============================
  // GLOBAL TABLE SEARCH RESULT
  // ===============================
  Widget _buildTableSearchResult() {
    return FutureBuilder<List<StatisticTable>>(
      future: _futureTables,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Gagal memuat tabel'));
        }

        final tables = snapshot.data ?? [];

        final filtered = tables.where((table) {
          final title = table.title?.toLowerCase() ?? '';
          return title.contains(_keyword);
        }).toList();

        if (filtered.isEmpty) {
          return const Center(child: Text('Tabel tidak ditemukan'));
        }

        return ListView.separated(
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final table = filtered[index];

            return ListTile(
              title: _highlight(table.title ?? '-', _keyword),
              subtitle: Text(
                '${table.subjectName ?? ''} • ${table.subsubjectName ?? ''}',
              ),
              trailing: const Icon(Icons.table_chart_outlined),
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
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Gagal memuat subjek turunan'),
          );
        }

        final items = snapshot.data ?? [];

        if (items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Tidak ada subjek turunan'),
          );
        }

        return Column(
          children: items.map((item) {
            return ListTile(
              title: Text(item.name ?? '-'),
              trailing: const Icon(Icons.chevron_right),
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
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(text: text.substring(0, i)),
          TextSpan(
            text: text.substring(i, i + k.length),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: text.substring(i + k.length)),
        ],
      ),
    );
  }
}
