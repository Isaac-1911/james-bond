class StatisticData {
  final int id;
  final int? categoryId;
  final String? title;
  final String? description;
  final double? value;
  final String? unit;
  final String? period;

  StatisticData({
    required this.id,
    this.categoryId,
    this.title,
    this.description,
    this.value,
    this.unit,
    this.period,
  });

  factory StatisticData.fromJson(Map<String, dynamic> json) {
    return StatisticData(
      id: json['statistic_id'] == null
    ? 0
    : json['statistic_id'] as int,
      categoryId: json['category_id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      value: json['value'] == null
          ? null
          : (json['value'] as num).toDouble(),
      unit: json['unit'] as String?,
      period: json['period'] as String?,
    );
  }
}