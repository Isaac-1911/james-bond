class Publication {
  final int id;
  final String? title;
  final String? release_date;
  final String? summary;
  final int publication_category;
  final String? cover_url;
  final String? description;
  final String? file_url;

  Publication({
    required this.id,
    this.title,
    this.release_date,
    this.summary,
    required this.publication_category,
    this.cover_url,
    this.description,
    this.file_url,
  });

  factory Publication.fromJson(Map<String, dynamic> json) {
    return Publication(
      id: json['publication_id'],
      title: json['title'],
      release_date: json['release_date'],
      summary: json['summary'],
      publication_category: json['publication_category'],
      cover_url: json['cover_url'],
      description: json['descripton'],
      file_url: json['file_url'],
    );
  }
}
