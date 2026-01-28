class StatisticPagination {
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  StatisticPagination({
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  factory StatisticPagination.fromJson(Map<String, dynamic> json) {
    return StatisticPagination(
      currentPage: json['currentPage'] as int,
      lastPage: json['lastPage'] as int,
      total: json['total'] as int,
      perPage: json['perPage'] as int
    );
  }
}
