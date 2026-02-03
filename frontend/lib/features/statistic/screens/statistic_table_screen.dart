import 'package:flutter/material.dart';
import 'package:excel/excel.dart' hide Border;
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../core/services/statistic_api_service.dart';
import '../../../models/statistic_table.dart';
import 'package:frontend/models/statistic_table_column.dart';
import 'package:frontend/models/statistic_table_row.dart';

class StatisticTableScreen extends StatefulWidget {
  final int tableId;
  final String title;

  const StatisticTableScreen({
    super.key,
    required this.tableId,
    required this.title,
  });

  @override
  State<StatisticTableScreen> createState() => _StatisticTableScreenState();
}

class _StatisticTableScreenState extends State<StatisticTableScreen> {
  late final Future<StatisticTable> _futureTable;

  @override
  void initState() {
    super.initState();
    _futureTable = StatisticApiService.getTableDetail(widget.tableId);
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
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AppBar(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF007AFF),
                      size: 18,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text(
                    'Detail Tabel',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF007AFF),
                      letterSpacing: 1.5,
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

            Expanded(
              child: FutureBuilder<StatisticTable>(
                future: _futureTable,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF007AFF),
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Gagal memuat tabel statistik',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  final table = snapshot.data;

                  if (table == null ||
                      table.columns.isEmpty ||
                      table.rows.isEmpty) {
                    return const Center(
                      child: Text(
                        'Data tabel tidak tersedia',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  return _buildScrollableTable(table);
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF007AFF), Color(0xFF0056CC)],
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
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Pilih Format Unduhan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Color(0xFFF8F8F8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: const Border.fromBorderSide(
                                        BorderSide(
                                          color: Color(0xFF007AFF),
                                          width: 1.5,
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF007AFF,
                                          ).withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _onExportCsv();
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.download_outlined,
                                            color: Color(0xFF007AFF),
                                            size: 24,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'CSV',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF007AFF),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF007AFF),
                                          Color(0xFF0056CC),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF007AFF,
                                          ).withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _onExportXlsx();
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.download_outlined,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'XLSX',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.download_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Unduh',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableTable(StatisticTable table) {
    final columns = [...table.columns]
      ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: Text(
            table.title ?? '',
            softWrap: true,
            maxLines: null,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.35,
            ),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(table, columns),
                  const SizedBox(height: 8),

                  ...table.rows.asMap().entries.map((entry) {
                    final index = entry.key;
                    final row = entry.value;

                    return _buildRow(table, columns, row).animate().fadeIn(
                      duration: 400.ms,
                      delay: (index * 40).ms,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    StatisticTable table,
    List<StatisticTableColumn> columns,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF007AFF), Color(0xFF0056CC)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007AFF).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: columns.map((col) {
          final unit = col.unit;
          final label = unit != null && unit.isNotEmpty
              ? '${col.label}\n($unit)'
              : col.label;

          return _buildCell(text: label ?? '-', isHeader: true);
        }).toList(),
      ),
    );
  }

  Widget _buildRow(
    StatisticTable table,
    List<StatisticTableColumn> columns,
    StatisticTableRow row,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: columns.map((col) {
          final value = row.data[col.key];
          return _buildCell(text: value?.toString() ?? '-');
        }).toList(),
      ),
    );
  }

  Widget _buildCell({required String text, bool isHeader = false}) {
    final isNumeric = double.tryParse(text.replaceAll(',', '')) != null;

    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      alignment: isHeader
          ? Alignment.center
          : (isNumeric ? Alignment.centerRight : Alignment.centerLeft),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? Colors.white : Colors.black87,
          fontSize: 14,
        ),
      ),
    );
  }

  Future<void> _onExportCsv() async {
    final table = await _futureTable;

    final columns = [...table.columns]
      ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

    final header = columns.map((c) => c.label ?? '').toList();

    final rows = table.rows.map((row) {
      return columns.map((col) {
        final value = row.data[col.key];
        return value?.toString() ?? '';
      }).toList();
    }).toList();

    final csvData = [header, ...rows];
    final csv = const ListToCsvConverter().convert(csvData);

    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${table.title?.replaceAll(' ', '_') ?? 'statistik'}.csv';
    final file = File('${directory.path}/$fileName');

    await file.writeAsString(csv);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CSV berhasil disimpan'),
        backgroundColor: Color(0xFF007AFF),
      ),
    );
  }

  Future<void> _onExportXlsx() async {
    final table = await _futureTable;

    final columns = [...table.columns]
      ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    sheet.appendRow(columns.map((c) => TextCellValue(c.label ?? '')).toList());

    for (final row in table.rows) {
      sheet.appendRow(
        columns.map((col) {
          final value = row.data[col.key];
          if (value is num) {
            return IntCellValue(value.toInt());
          }
          return TextCellValue(value?.toString() ?? '');
        }).toList(),
      );
    }

    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${table.title?.replaceAll(' ', '_') ?? 'statistik'}.xlsx';
    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(excel.encode()!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('XLSX berhasil disimpan'),
        backgroundColor: Color(0xFF007AFF),
      ),
    );
  }
}
