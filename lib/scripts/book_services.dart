import "package:google_books_api/google_books_api.dart";

class BookServices {
  static Future<List<Book>> searchBooksByCategory(String category) async {
    if (category == "") {
      return [];
    }
    final books = await const GoogleBooksApi()
        .searchBooks(category, queryType: QueryType.subject);
    return books;
  }
}
