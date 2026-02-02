import 'statistic_table_column.dart';
import 'statistic_table_row.dart';

class StatisticTable {
  final int? id;
  final String? title;
  final String? description;
  final String? source;
  final DateTime? lastUpdated;

  // 🔥 METADATA TAMBAHAN (UNTUK SEARCH GLOBAL)
  final String? subjectName;
  final String? subsubjectName;

  // 🔥 TETAP ADA — JANGAN DIHAPUS
  final List<StatisticTableColumn> columns;
  final List<StatisticTableRow> rows;

  StatisticTable({
    this.id,
    this.title,
    this.description,
    this.source,
    this.lastUpdated,
    this.subjectName,
    this.subsubjectName,
    this.columns = const [],
    this.rows = const [],
  });

  factory StatisticTable.fromJson(Map<String, dynamic> json) {
    return StatisticTable(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      source: json['source'],
      lastUpdated: json['last_updated'] != null
          ? DateTime.tryParse(json['last_updated'])
          : null,

      // 🔥 FIELD OPSIONAL (AMAN KALAU TIDAK ADA)
      subjectName: json['subject_name'],
      subsubjectName: json['subsubject_name'],

      // 🔥 TETAP PARSE DINAMIS
      columns: (json['columns'] as List? ?? [])
          .map((e) => StatisticTableColumn.fromJson(e))
          .toList(),
      rows: (json['rows'] as List? ?? [])
          .map((e) => StatisticTableRow.fromJson(e))
          .toList(),
    );
  }
}
