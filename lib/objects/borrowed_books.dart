import 'package:google_books_api/google_books_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_books_api/google_books_api.dart';

class BorrowedBooks {
  String? id;
  int? requestId;
  DateTime? borrowedAt;
  DateTime? dueDate;
  DateTime? returnedAt;
  Book? book;
  int? durationNo, durationUnit;
  String? image, title;
  BorrowedBooks(
      {this.id,
      this.durationNo,
      this.durationUnit,
      this.borrowedAt,
      this.dueDate,
      this.returnedAt,
      this.image,
      this.title,
      this.book});
  //daoooottt
  factory BorrowedBooks.fromJson(Map<String, dynamic> json) {
    var borrowedBook = BorrowedBooks(
      id: json['book_id'],
      borrowedAt: DateTime.fromMicrosecondsSinceEpoch(
          json['borrowedAt'].microsecondsSinceEpoch),
      dueDate: DateTime.fromMicrosecondsSinceEpoch(
          json['due_date'].microsecondsSinceEpoch),
      returnedAt: json['returned_at'] == null
          ? null
          : DateTime.fromMicrosecondsSinceEpoch(
              json['returned_at'].microsecondsSinceEpoch),
      durationNo: json['duration_no'],
      durationUnit: json['duration_unit'],
    );

    return borrowedBook;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'borrowed_at': borrowedAt?.toIso8601String(),
      'returned_at': returnedAt?.toIso8601String(),
    };
  }

  Future<Book> getBook() async {
    var book = await GoogleBooksApi().getBookById(id!);
    this.book = book;
    return book;
  }
}




/*CREATE TABLE `borrowed_books` (
  `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `request_id` INT(11) NOT NULL,
  `borrowed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `due_date` DATE NOT NULL,
  `returned_at` TIMESTAMP NULL DEFAULT NULL,
  Foreign Key (`request_id`) REFERENCES `borrow_request`(`id`)
); */