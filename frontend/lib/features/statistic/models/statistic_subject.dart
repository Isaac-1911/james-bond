class StatisticSubject {
  final int id;
  final String name;
  final String slug;

  StatisticSubject({required this.id, required this.name, required this.slug});

  factory StatisticSubject.fromJson(Map<String, dynamic> json) {
    return StatisticSubject(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String
    );
  }
}
