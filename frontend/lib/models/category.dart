class Category {
  final int id;
  final String? name;
  final String? description;

  Category({
    required this.id,
    this.name,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.tryParse(json['category_id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString(),
      description: json['description']?.toString(),
    );
  }
}
