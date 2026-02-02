import 'package:flutter/material.dart';
import '../../../core/services/statistic_api_service.dart';
import '../../../models/statistic_subject.dart';
import '../../../models/statistic_subsubject.dart';
import 'statistic_table_list_screen.dart';

class StatisticListScreen extends StatefulWidget {
  const StatisticListScreen({super.key});

  @override
  State<StatisticListScreen> createState() => _StatisticListScreenState();
}

class _StatisticListScreenState extends State<StatisticListScreen> {
  late Future<List<StatisticSubject>> _futureSubjects;
  final TextEditingController _searchController = TextEditingController();
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _futureSubjects = StatisticApiService.getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tabel Statistik')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: _onSearchSubmit,
                    decoration: InputDecoration(
                      hintText: 'Cari Tabel di sini',
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
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<List<StatisticSubject>>(
              future: _futureSubjects,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Gagal memuat data statistik'),
                  );
                }

                final subjects = snapshot.data ?? [];
                final filteredSubjects = _keyword.isEmpty
                    ? subjects
                    : subjects.where((subject) {
                        final subjectName = subject.name?.toLowerCase() ?? '';
                        return subjectName.contains(_keyword);
                      }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredSubjects.length,
                  itemBuilder: (context, index) {
                    final subject = filteredSubjects[index];

                    return _SubjectExpansion(
                      subject: subject,
                      keyword: _keyword,
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

  void _onSearchSubmit(String value) {
    setState(() {
      _keyword = value.trim().toLowerCase();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _keyword = '';
    });
  }
}

class _SubjectExpansion extends StatefulWidget {
  final StatisticSubject subject;
  final String keyword;

  const _SubjectExpansion({required this.subject, required this.keyword});

  @override
  State<_SubjectExpansion> createState() => _SubjectExpansionState();
}

class _SubjectExpansionState extends State<_SubjectExpansion> {
  late Future<List<StatisticSubsubject>> _futureSubsubjects;

  @override
  void initState() {
    super.initState();
    _futureSubsubjects = StatisticApiService.getSubsubjects(widget.subject.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        title: Text(
          widget.subject.name ?? '-',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        children: [
          FutureBuilder<List<StatisticSubsubject>>(
            future: _futureSubsubjects,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                );
              }

              final subs = snapshot.data ?? [];

              final filteredSubs = widget.keyword.isEmpty
                  ? subs
                  : subs.where((sub) {
                      final subName = sub.name?.toLowerCase() ?? '';
                      return subName.contains(widget.keyword);
                    }).toList();

              return Column(
                children: subs.map((sub) {
                  return ListTile(
                    title: Text(sub.name ?? '-'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StatisticTableListScreen(
                            subsubjectId: sub.id!,
                            title: sub.name ?? '',
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
