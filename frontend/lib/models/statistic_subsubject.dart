class StatisticSubsubject {
  final int? id;
  final int? subjectId;
  final String? name;
  final String? description;

  StatisticSubsubject({this.id, this.subjectId, this.name, this.description});

  factory StatisticSubsubject.fromJson(Map<String, dynamic> json) {
  return StatisticSubsubject(
    id: json['id'] ?? json['subsubject_id'],
    subjectId: json['subject_id'],
    name: json['name'] as String?,
    description: json['description'] as String?,
  );
}

}
