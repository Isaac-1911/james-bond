class News {
  final int id;
  final String title;
  final String? summary;
  final String? imageUrl;
  final String? releaseDate;

  News({
    required this.id,
    required this.title,
    this.summary,
    this.imageUrl,
    this.releaseDate,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: int.tryParse(json['news_id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString(),
      imageUrl: json['image_url']?.toString(),
      releaseDate: json['release_date']?.toString(),
    );
  }
}
