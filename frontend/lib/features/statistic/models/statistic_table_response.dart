import 'package:frontend/features/statistic/models/statistic_column.dart';
import 'package:frontend/features/statistic/models/statistic_indicator.dart';
import 'package:frontend/features/statistic/models/statistic_pagination.dart';
import 'package:frontend/features/statistic/models/statistic_row.dart';

class StatisticTableResponse {
  final StatisticIndicator indicator;
  final List<StatisticColumn> columns;
  final List<StatisticRow> rows;
  final StatisticPagination pagination;

  StatisticTableResponse({
    required this.indicator,
    required this.columns,
    required this.rows,
    required this.pagination,
  });

  factory StatisticTableResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> meta =
        json['meta'] as Map<String, dynamic>;
    final Map<String, dynamic> data =
        json['data'] as Map<String, dynamic>;

    return StatisticTableResponse(
      indicator:
          StatisticIndicator.fromJson(meta['indicator'] as Map<String, dynamic>),
      columns: (meta['columns'] as List)
          .map((e) =>
              StatisticColumn.fromJson(e as Map<String, dynamic>))
          .toList(),
      rows: (data['items'] as List)
          .map((e) => StatisticRow.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: StatisticPagination.fromJson(
          data['pagination'] as Map<String, dynamic>),
    );
  }
}

