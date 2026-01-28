class StatisticColumn {
  final String key;
  final String label;
  final String type;

  StatisticColumn({required this.key, required this.label, required this.type});

  factory StatisticColumn.fromJson(Map<String, dynamic> json) {
    return StatisticColumn(
      key: json['key'] as String,
      label: json['label'] as String,
      type: json['type'] as String
    );
  }
}
