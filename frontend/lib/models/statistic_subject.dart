class StatisticSubject {
  final int? id;
  final String name;
  final String? description;

  StatisticSubject({
    this.id,
    required this.name,
    this.description,
  });

  factory StatisticSubject.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['subject_id'];

    return StatisticSubject(
      id: rawId == null ? null : int.tryParse(rawId.toString()),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
    );
  }
}
