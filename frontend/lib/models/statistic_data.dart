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
      id: int.tryParse(json['statistic_id']?.toString() ?? '') ?? 0,
      categoryId: int.tryParse(json['category_id']?.toString() ?? ''),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      value: json['value'] != null
          ? double.tryParse(json['value'].toString())
          : null,
      unit: json['unit']?.toString(),
      period: json['period']?.toString(),
    );
  }
}
