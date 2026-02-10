class Infographic {
  final int id;
  final String title;
  final String? description;
  final String imageUrl;

  Infographic({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
  });

  factory Infographic.fromJson(Map<String, dynamic> json) {
    return Infographic(
      id: int.tryParse(json['infographic_id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      imageUrl: json['image_url']?.toString() ?? '',
    );
  }
}
