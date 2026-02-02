class StatisticTableColumn {
  final String? key;
  final String? label;
  final String? unit;
  final int? order;

  StatisticTableColumn({this.key, this.label, this.unit, this.order});

  factory StatisticTableColumn.fromJson(Map<String, dynamic> json) {
    return StatisticTableColumn(
      key: json['key_name'] as String?,
      label: json['label'] as String?,
      unit: json['unit'] as String?,
      order: json['order'] as int?
    );
  }
}
