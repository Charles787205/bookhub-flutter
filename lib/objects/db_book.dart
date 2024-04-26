class Book {
  final String id;
  final String title;
  final String? image;

  Book({required this.id, required this.title, this.image});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      image: json['image'],
    );
  }
}
