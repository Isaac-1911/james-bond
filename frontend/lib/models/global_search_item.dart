enum SearchItemType { news, publication, statistic, infographic }

class GlobalSearchItem {
  final SearchItemType type;
  final int id;
  final String title;
  final String? subtitle;
  final String tag;

  GlobalSearchItem({
    required this.type,
    required this.id,
    required this.title,
    this.subtitle,
    required this.tag
  });

  
}
