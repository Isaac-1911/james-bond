class StatisticTableRow {
  final String label;
  final Map<String, dynamic> data;

  StatisticTableRow({
    required this.label,
    required this.data,
  });

  factory StatisticTableRow.fromJson(Map<String, dynamic> json) {
    return StatisticTableRow(
      label: json['label'], 
      data: Map<String, dynamic>.from(json['data']),
    );
  }
}
