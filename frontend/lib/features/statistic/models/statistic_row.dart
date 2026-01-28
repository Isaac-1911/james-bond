class StatisticRow {
  final Map<String, dynamic> values;

  StatisticRow(this.values);

  dynamic operator [](String key) => values[key];

  factory StatisticRow.fromJson(Map<String, dynamic> json) {
    return StatisticRow(json);
  }
}
