class ReleasePlan {
  final int id;
  final String title;
  final ReleaseType type;
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
    final rawId = json['id'];
    final rawPlanned = json['planned_date'];
    final rawReleased = json['released_date'];
    final rawTarget = json['target_id'];
    final rawType = json['type'];

    return ReleasePlan(
      id: int.tryParse(rawId?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      type: ReleaseTypeX.fromString(rawType),
      plannedDate:
          DateTime.tryParse(rawPlanned?.toString() ?? '') ?? DateTime(1970),
      releasedDate: rawReleased == null
          ? null
          : DateTime.tryParse(rawReleased.toString()),
      targetId: rawTarget == null
          ? null
          : int.tryParse(rawTarget.toString()),
    );
  }
}

enum ReleaseType { publikasi, brs }

extension ReleaseTypeX on ReleaseType {
  static ReleaseType fromString(dynamic value) {
    switch (value?.toString()) {
      case 'publikasi':
        return ReleaseType.publikasi;
      case 'brs':
        return ReleaseType.brs;
      default:
        return ReleaseType.publikasi; // fallback aman
    }
  }

  String get label {
    switch (this) {
      case ReleaseType.publikasi:
        return 'Publikasi';
      case ReleaseType.brs:
        return 'BRS';
    }
  }
}

