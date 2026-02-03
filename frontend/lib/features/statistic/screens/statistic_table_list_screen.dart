import 'package:flutter/material.dart';
import 'dart:ui'; // Tambahkan untuk ImageFilter (blur)
import 'package:flutter_animate/flutter_animate.dart'; // Plugin untuk animasi smooth (opsional, jika tidak ingin, ganti dengan AnimatedOpacity)
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
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AppBar(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF007AFF),
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
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

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
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
                  onChanged: (value) {
                    setState(() {
                      _keyword = value.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari Tabel di sini',
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
                      borderRadius: BorderRadius.circular(
                        24,
                      ), // Lebih rounded untuk futuristik
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

            // 📋 LIST TABLE DENGAN SHADOW DAN ANIMASI
            Expanded(
              child: FutureBuilder<List<StatisticTable>>(
                future: _futureTables,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF007AFF),
                        ), // Warna biru BPS
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

                  final filteredTables = _keyword.isEmpty
                      ? tables
                      : tables.where((table) {
                          final title = table.title?.toLowerCase() ?? '';
                          return title.contains(_keyword);
                        }).toList();

                  if (filteredTables.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tabel tidak ditemukan',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    itemCount: filteredTables.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final table = filteredTables[index];

                      return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 10, // lebih lembut
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12, // 🔥 nafas di dalam card
                              ),
                              title: Text(
                                table.title ?? '-',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.25, // 🔥 jarak antar baris teks
                                ),
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
                          )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: (index * 80).ms)
                          .slideY(begin: 0.08, end: 0); // iOS-like halus
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
