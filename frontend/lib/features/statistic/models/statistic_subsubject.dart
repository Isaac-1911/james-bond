class StatisticSubsubject {
  final int id;
  final String name;
  final String slug;

  StatisticSubsubject({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory StatisticSubsubject.fromJson(Map<String, dynamic> json) {
    return StatisticSubsubject(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }
}
