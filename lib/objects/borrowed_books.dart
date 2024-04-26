import 'package:bookhub/objects/db_book.dart';

class BorrowedBooks {
  int? id;
  int? requestId;
  DateTime? borrowedAt;
  DateTime? dueDate;
  DateTime? returnedAt;
  Book? book;

  BorrowedBooks(
      {this.id,
      this.requestId,
      this.borrowedAt,
      this.dueDate,
      this.returnedAt,
      this.book});

  factory BorrowedBooks.fromJson(Map<String, dynamic> json) {
    return BorrowedBooks(
        id: int.parse(json['id']),
        requestId: int.parse(json['request_id']),
        borrowedAt: DateTime.parse(json['borrowed_at']),
        dueDate: DateTime.parse(json['due_date']),
        returnedAt: json['returned_at'] == null
            ? null
            : DateTime.parse(json['returned_at']),
        book: json['book'] != null ? Book.fromJson(json['book']) : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'borrowed_at': borrowedAt?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'returned_at': returnedAt?.toIso8601String(),
    };
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