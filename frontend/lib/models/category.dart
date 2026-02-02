class Category {
  final int id;
  final String? name;
  final String? description;

  Category({required this.id, this.name, this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['category_id'],
      name: json['name'],
      description: json['description']
    );
  }
}
