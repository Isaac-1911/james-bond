class Publication {
  final int id;
  final String title;
  final String? releaseDate;
  final String? summary;
  final int? publicationCategory;
  final String? coverUrl;
  final String? description;
  final String? fileUrl;
  final int? catalogNumber;
  final String? publicationNumber;
  final String? isbn;

  Publication({
    required this.id,
    required this.title,
    this.releaseDate,
    this.summary,
    this.publicationCategory,
    this.coverUrl,
    this.description,
    this.fileUrl,
    this.catalogNumber,
    this.publicationNumber,
    this.isbn
  });

  factory Publication.fromJson(Map<String, dynamic> json) {
  return Publication(
    id: json['publication_id'] as int,
    title: json['title'] as String,
    releaseDate: json['release_date'] as String?,
    summary: json['summary'] as String?,
    publicationCategory: json['publication_category'] as int?,
    coverUrl: json['cover_url'] as String?,
    description: json['description'] as String?,
    fileUrl: json['file_url'] as String?,
    catalogNumber: json['catalog_number'] as int?,
    publicationNumber: json['publication_number'] as String?,
    isbn: json['isbn'] as String?,
  );
}
}
