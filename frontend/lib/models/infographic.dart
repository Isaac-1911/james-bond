class Infographic {
  final int id;
  final String title;
  final String? description;
  final String image_url;

  Infographic({
    required this.id,
    required this.title,
    this.description,
    required this.image_url,
  });

  factory Infographic.fromJson(Map<String, dynamic> json) {
    return Infographic(
      id: json['infographic_id'],
      title: json['title'],
      description: json['description'],
      image_url: json['image_url']
    );
  }
}
