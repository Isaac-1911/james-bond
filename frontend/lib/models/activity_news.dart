class ActivityNews {
  final int id;
  final String title;
  final String? summary;
  final String? imageUrl;
  final String? releaseDate;

  ActivityNews({
    required this.id,
    required this.title,
    this.summary,
    this.imageUrl,
    this.releaseDate,
  });

  factory ActivityNews.fromJson(Map<String, dynamic> json) {
    return ActivityNews(
      id: int.tryParse(json['activity_news_id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString(),
      imageUrl: json['image_url']?.toString(),
      releaseDate: json['release_date']?.toString(),
    );
  }
}
