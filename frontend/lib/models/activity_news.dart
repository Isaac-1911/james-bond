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
      id: json['activity_news_id'] as int,
      title: json['title'] as String,
      summary: json['summary'] as String,
      imageUrl: json['image_url'] as String,
      releaseDate: json['release_date'] as String
    );
  }
}
