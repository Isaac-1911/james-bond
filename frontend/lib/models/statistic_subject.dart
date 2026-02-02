class StatisticSubject {
  final int? id;
  final String? name;
  final String? description;

  StatisticSubject({this.id, this.name, this.description});

  factory StatisticSubject.fromJson(Map<String, dynamic> json) {
  return StatisticSubject(
    id: json['id'] ?? json['subject_id'],
    name: json['name'] as String?,
    description: json['description'] as String?,
  );
}

}
