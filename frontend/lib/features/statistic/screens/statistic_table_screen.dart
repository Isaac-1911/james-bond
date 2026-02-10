import 'package:flutter/material.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../core/services/statistic_api_service.dart';
import '../../../models/statistic_table.dart';
import '../widgets/assistant_bottom_sheet.dart';
import 'package:frontend/models/statistic_table_column.dart';
import 'package:frontend/models/statistic_table_row.dart';
import 'package:intl/intl.dart';

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
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  final StatisticApiService _statisticApi = StatisticApiService();
  @override
  void initState() {
    super.initState();
    _futureTable = _statisticApi.getTableDetail(widget.tableId);
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  void _openAssistantBottomSheet(int tableId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          AssistantBottomSheet(tableId: tableId, tableTitle: widget.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: FutureBuilder<StatisticTable>(
              future: _futureTable,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoadingState();
                }

                if (snapshot.hasError) {
                  return _buildErrorState();
                }

                final table = snapshot.data;

                if (table == null ||
                    table.columns.isEmpty ||
                    table.rows.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildContent(table);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildDownloadButton(),
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
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF007AFF),
                    size: 22,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Detail Tabel',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1D1F),
                  ),
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
      ),
    );
  }

  Widget _buildLoadingState() {
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
            'Memuat tabel statistik...',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
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
          const Text(
            'Gagal memuat tabel statistik',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba lagi nanti atau periksa koneksi internet',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 160,
            height: 44,
            child: ElevatedButton(
              onPressed: () => setState(() {}),
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
              Icons.table_chart_outlined,
              color: Color(0xFF007AFF),
              size: 36,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Data tabel tidak tersedia',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tidak ada data untuk ditampilkan',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(StatisticTable table) {
    final columns = [...table.columns]
      ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  table.title ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1D1F),
                  ),
                ),
                if (table.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    table.description!,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${columns.length} Kolom',
                        style: const TextStyle(
                          color: Color(0xFF007AFF),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34C759).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${table.rows.length} Baris',
                        style: const TextStyle(
                          color: Color(0xFF34C759),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (table.lastUpdated != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9500).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.update_rounded,
                              size: 12,
                              color: Color(0xFFFF9500),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Update: ${DateFormat('dd MMM yyyy').format(table.lastUpdated!)}',
                              style: const TextStyle(
                                color: Color(0xFFFF9500),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // ===============================
                // BLOK TANYA ASISTEN
                // ===============================
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF007AFF).withValues(alpha: 0.05),
                        const Color(0xFF34C759).withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF007AFF).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.smart_toy_rounded,
                          size: 20,
                          color: Color(0xFF007AFF),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Butuh bantuan?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1D1D1F),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Asisten AI siap membantu memahami data tabel ini',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            _openAssistantBottomSheet(table.id!);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007AFF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Tanya',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: _buildTableWithScroll(columns, table.rows)),
      ],
    );
  }

  Widget _buildTableWithScroll(
    List<StatisticTableColumn> columns,
    List<StatisticTableRow> rows,
  ) {
    final totalWidth = columns.length * 200.0;
    final screenWidth = MediaQuery.of(context).size.width - 40;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Scrollbar(
        controller: _horizontalScrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _horizontalScrollController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: totalWidth > screenWidth ? totalWidth : screenWidth,
            child: Column(
              children: [
                // ================= HEADER (STICKY) =================
                Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(children: columns.map(_buildHeaderCell).toList()),
                ),

                // ================= BODY =================
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Scrollbar(
                      controller: _verticalScrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _verticalScrollController,
                        child: Column(
                          children: List.generate(rows.length, (index) {
                            return _buildDataRow(columns, rows[index], index);
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(StatisticTableColumn col) {
    return SizedBox(
      width: 200,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              col.label ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (col.unit != null && col.unit!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                col.unit!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(
    List<StatisticTableColumn> columns,
    StatisticTableRow row,
    int index,
  ) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: columns.map((col) {
          final value = row.data[col.key];
          return _buildDataCell(value?.toString() ?? '', index);
        }).toList(),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: (index * 40).ms);
  }

  Widget _buildDataCell(String text, int index) {
    final isNumeric = double.tryParse(text.replaceAll(',', '')) != null;

    return SizedBox(
      width: 200,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: index % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA),
          border: Border(
            right: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Align(
          alignment: isNumeric ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800,
              fontWeight: isNumeric ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _showDownloadOptions,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download_rounded, size: 22),
                SizedBox(width: 10),
                Text(
                  'Unduh Data',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDownloadOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Pilih Format Unduhan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1D1F),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Data akan disimpan di penyimpanan perangkat',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _onExportCsv();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF007AFF),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF007AFF,
                                  ).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.text_fields_rounded,
                                  color: Color(0xFF007AFF),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'CSV',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF007AFF),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'File teks dengan pemisah koma',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          _onExportXlsx();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF007AFF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.table_chart_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Excel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'File spreadsheet lengkap',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onExportCsv() async {
    try {
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
      final fileName =
          '${table.title?.replaceAll(' ', '_') ?? 'statistik'}.csv';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(csv);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF34C759),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'CSV berhasil disimpan',
                style: TextStyle(color: Colors.white),
                maxLines: 2,
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFFF3B30),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Gagal menyimpan CSV',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _onExportXlsx() async {
    try {
      final table = await _futureTable;

      final columns = [...table.columns]
        ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      sheet.appendRow(
        columns.map((c) => TextCellValue(c.label ?? '')).toList(),
      );

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
      final fileName =
          '${table.title?.replaceAll(' ', '_') ?? 'statistik'}.xlsx';
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(excel.encode()!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF34C759),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Excel berhasil disimpan',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFFF3B30),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Gagal menyimpan Excel',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }
  }
}
