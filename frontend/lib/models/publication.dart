class Publication {
  final int publicationId;
  final String title;
  final String? releaseDate;
  final String? summary;
  final String publicationCategory;
  final String? coverUrl;
  final String? description;
  final String? fileUrl;
  final String catalogNumber;
  final String publicationNumber;
  final String isbn;
  final int? downloadCount;

  Publication({
    required this.publicationId,
    required this.title,
    this.releaseDate,
    this.summary,
    required this.publicationCategory,
    this.coverUrl,
    this.description,
    this.fileUrl,
    required this.catalogNumber,
    required this.publicationNumber,
    required this.isbn,
    this.downloadCount,
  });

  factory Publication.fromJson(Map<String, dynamic> json) {
    return Publication(
      publicationId: int.parse(json['publication_id'].toString()),
      title: json['title']?.toString() ?? '',

      releaseDate: json['release_date']?.toString(),
      summary: json['summary']?.toString(),
      description: json['description']?.toString(),

      coverUrl: json['cover_url']?.toString(),
      fileUrl: json['file_url']?.toString(),

      publicationCategory: json['publication_category']?.toString() ?? '',

      catalogNumber: json['catalog_number']?.toString() ?? '',
      publicationNumber: json['publication_number']?.toString() ?? '',
      isbn: json['isbn']?.toString() ?? '',

      downloadCount:
          int.tryParse(json['download_count']?.toString() ?? ''),
    );
  }
}
