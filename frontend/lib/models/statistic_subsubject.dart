class StatisticSubsubject {
  final int? id;
  final int? subjectId;
  final String name;
  final String? description;

  StatisticSubsubject({
    this.id,
    this.subjectId,
    required this.name,
    this.description,
  });

  factory StatisticSubsubject.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['subsubject_id'];
    final rawSubjectId = json['subject_id'] ?? json['subjectId'];

    return StatisticSubsubject(
      id: rawId == null ? null : int.tryParse(rawId.toString()),
      subjectId:
          rawSubjectId == null ? null : int.tryParse(rawSubjectId.toString()),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
    );
  }
}
