import 'package:bookhub/objects/db_book.dart';
import 'package:bookhub/objects/user.dart';

class BookRequest {
  static const String STATUS_PENDING = "pending";
  static const String STATUS_APPROVED = "approved";
  static const String STATUS_REJECTED = "rejected";

  int? id;
  String? userId;
  String? bookId;
  String? status;
  String? requestedAt;
  String? requestAt;
  String? durationNo;
  String? durationUnit;
  Book? book;
  User? user;

  BookRequest(
      {this.id,
      this.userId,
      this.bookId,
      this.status,
      this.requestedAt,
      this.requestAt,
      this.durationNo,
      this.durationUnit,
      this.book,
      this.user});

  BookRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bookId = json['book_id'];
    status = json['status'];
    requestedAt = json['requested_at'];
    requestAt = json['request_at'];
    durationNo = json['duration_no'];
    durationUnit = json['duration_unit'];
    book = json['book'] != null ? Book.fromJson(json['book']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
}
