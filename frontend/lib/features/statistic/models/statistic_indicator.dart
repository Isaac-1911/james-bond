class StatisticIndicator {
  final int id;
  final String title;
  final String? unit;
  final String? description;

  StatisticIndicator({
    required this.id,
    required this.title,
    this.unit,
    this.description,
  });

  factory StatisticIndicator.fromJson(Map<String, dynamic> json) {
    return StatisticIndicator(
      id: json['id'] as int,
      title: json['title'] as String,
      unit: json['unit'] as String?,
      description: json['description'] as String?,
    );
  }
}
