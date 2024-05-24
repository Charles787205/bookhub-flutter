class Book {
  final String id;
  final String title;
  final String? image;
  final double? rating;

  Book({required this.id, required this.title, this.image, this.rating});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      rating: json['rating'],
    );
  }
}
