class ReleasePlan {
  final int id;
  final String title;
  final String type;
  final DateTime plannedDate;
  final DateTime? releasedDate;
  final int? targetId;

  ReleasePlan({
    required this.id,
    required this.title,
    required this.type,
    required this.plannedDate,
    this.releasedDate,
    this.targetId,
  });

  bool get isReleased => releasedDate != null;

  factory ReleasePlan.fromJson(Map<String, dynamic> json) {
    return ReleasePlan(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      plannedDate: DateTime.parse(json['planned_date']),
      releasedDate: json['released_date'] != null
          ? DateTime.parse(json['released_date'])
          : null,
      targetId: json['target_id']
    );
  }
}
