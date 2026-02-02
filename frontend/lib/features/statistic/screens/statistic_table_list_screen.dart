import 'package:flutter/material.dart';
import '../../../core/services/statistic_api_service.dart';
import '../../../models/statistic_table.dart';
import 'statistic_table_screen.dart';

class StatisticTableListScreen extends StatefulWidget {
  final int subsubjectId;
  final String title;

  const StatisticTableListScreen({
    super.key,
    required this.subsubjectId,
    required this.title,
  });

  @override
  State<StatisticTableListScreen> createState() =>
      _StatisticTableListScreenState();
}

class _StatisticTableListScreenState extends State<StatisticTableListScreen> {
  late final Future<List<StatisticTable>> _futureTables;

  final TextEditingController _searchController = TextEditingController();
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _futureTables = StatisticApiService.getTables(widget.subsubjectId);
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
      appBar: AppBar(title: Text(widget.title)),
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

          // 📋 LIST TABLE
          Expanded(
            child: FutureBuilder<List<StatisticTable>>(
              future: _futureTables,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Gagal memuat tabel'));
                }

                final tables = snapshot.data ?? [];

                final filteredTables = _keyword.isEmpty
                    ? tables
                    : tables.where((table) {
                        final title =
                            table.title?.toLowerCase() ?? '';
                        return title.contains(_keyword);
                      }).toList();

                if (filteredTables.isEmpty) {
                  return const Center(child: Text('Tabel tidak ditemukan'));
                }

                return ListView.separated(
                  itemCount: filteredTables.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final table = filteredTables[index];

                    return ListTile(
                      title: Text(table.title ?? '-'),
                      trailing:
                          const Icon(Icons.table_chart_outlined),
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
            ),
          ),
        ],
      ),
    );
  }
}
