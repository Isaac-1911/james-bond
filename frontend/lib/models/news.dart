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
    this.releaseDate
  });

  factory News.fromJson(Map<String, dynamic> json){
    return News(
      id: json['news_id'],
      title: json['title'],
      summary: json['summary'],
      imageUrl: json['image_url'],
      releaseDate: json['release_date']
    );
  }

}
