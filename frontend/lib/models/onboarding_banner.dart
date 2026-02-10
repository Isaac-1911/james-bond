class OnboardingBanner {
  final int id;
  final String imageUrl;
  final String? title;

  OnboardingBanner({
    required this.id,
    required this.imageUrl,
    this.title,
  });

  factory OnboardingBanner.fromJson(Map<String, dynamic> json) {
    return OnboardingBanner(
      id: json['id'],
      imageUrl: json['image_url'],
      title: json['title'],
    );
  }
}
