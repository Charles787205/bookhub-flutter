import 'package:bookhub/scripts/firebasehandler.dart';
import 'package:google_books_api/google_books_api.dart';

class ReturnedBook {
  String? id;
  DateTime? returnedAt;
  Book? book;
  ReturnedBook({this.id, this.returnedAt, this.book});

  factory ReturnedBook.fromJson(Map<String, dynamic> json) {
    var returnedBook = ReturnedBook(
      id: json['book_id'],
      returnedAt: DateTime.fromMicrosecondsSinceEpoch(
          json['returnedAt'].microsecondsSinceEpoch),
    );

    return returnedBook;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'returnedAt': returnedAt?.toIso8601String(),
    };
  }

  Future<Book> getBook() async {
    var book = await GoogleBooksApi().getBookById(id!);
    this.book = book;
    return book;
  }
}
