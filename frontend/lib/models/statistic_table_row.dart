class StatisticTableRow {
  final Map<String, dynamic> data;

  StatisticTableRow({required this.data});

  factory StatisticTableRow.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    if (rawData is Map<String, dynamic>) {
      return StatisticTableRow(data: rawData);
    }

    return StatisticTableRow(data: {});
  }
}
