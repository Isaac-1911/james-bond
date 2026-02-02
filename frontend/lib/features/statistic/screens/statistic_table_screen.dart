import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../core/services/statistic_api_service.dart';
import '../../../models/statistic_table.dart';

class StatisticTableScreen extends StatefulWidget {
  final int tableId;
  final String title;

  const StatisticTableScreen({
    super.key,
    required this.tableId,
    required this.title,
  });

  @override
  State<StatisticTableScreen> createState() =>
      _StatisticTableScreenState();
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
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _onExportCsv,
          ),
        ],
      ),
      body: FutureBuilder<StatisticTable>(
        future: _futureTable,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Gagal memuat tabel statistik'),
            );
          }

          final table = snapshot.data;

          if (table == null ||
              table.columns.isEmpty ||
              table.rows.isEmpty) {
            return const Center(
              child: Text('Data tabel tidak tersedia'),
            );
          }

          return _buildScrollableTable(table);
        },
      ),
    );
  }

  // ===============================
  // TABLE UI
  // ===============================
  Widget _buildScrollableTable(StatisticTable table) {
    final columns = [...table.columns]
      ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(columns),
            const Divider(height: 1),
            ...table.rows.map(
              (row) => _buildRow(columns, row),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(List columns) {
    return Container(
      color: Colors.grey.shade200,
      child: Row(
        children: columns.map<Widget>((col) {
          final unit = col.unit;
          final label = unit != null && unit.isNotEmpty
              ? '${col.label}\n($unit)'
              : col.label ?? '-';

          return _buildCell(text: label, isHeader: true);
        }).toList(),
      ),
    );
  }

  Widget _buildRow(List columns, row) {
    return Row(
      children: columns.map<Widget>((col) {
        final value = row.data[col.key];
        return _buildCell(text: value?.toString() ?? '-');
      }).toList(),
    );
  }

  Widget _buildCell({
    required String text,
    bool isHeader = false,
  }) {
    final isNumeric =
        double.tryParse(text.replaceAll(',', '')) != null;

    return Container(
      width: 140,
      padding: const EdgeInsets.all(8),
      alignment: isHeader
          ? Alignment.center
          : (isNumeric
              ? Alignment.centerRight
              : Alignment.centerLeft),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade300),
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Text(
        text,
        textAlign: isNumeric ? TextAlign.right : TextAlign.left,
        style: TextStyle(
          fontWeight:
              isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // ===============================
  // CSV EXPORT
  // ===============================
  Future<void> _onExportCsv() async {
    final table = await _futureTable;

    final columns = [...table.columns]
      ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

    final header =
        columns.map((c) => c.label ?? '').toList();

    final rows = table.rows.map((row) {
      return columns.map((col) {
        final value = row.data[col.key];
        return value?.toString() ?? '';
      }).toList();
    }).toList();

    final csvData = [header, ...rows];
    final csv =
        const ListToCsvConverter().convert(csvData);

    final directory =
        await getApplicationDocumentsDirectory();
    final fileName =
        '${table.title?.replaceAll(' ', '_') ?? 'statistik'}.csv';
    final file = File('${directory.path}/$fileName');

    await file.writeAsString(csv);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV berhasil disimpan')),
    );
  }
}
