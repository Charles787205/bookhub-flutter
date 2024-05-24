import 'dart:convert';
import 'package:google_books_api/google_books_api.dart';
import 'package:http/http.dart' as http;
import 'package:bookhub/objects/user.dart';
import 'package:bookhub/objects/borrowed_books.dart';
import 'package:bookhub/objects/db_book.dart' as DBook;

class DatabaseConnector {
  static String url = "192.168.55.164";
  //static String url = "10.0.2.2";
  //static String url = "localhost:3000"; // Google chrome
  static Future<User?> login(String email, String password) async {
    var response = await http.post(Uri.http(url, "/bookhub/api/user/login.php"),
        body: jsonEncode(<String, String>{
          'password': password,
          'email': email,
        }));

    if (response.statusCode == 200) {
      if (jsonDecode(response.body) == "null") {
        return null;
      }
      return User.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<User?> register(User user) async {
    var response =
        await http.post(Uri.http(url, "/bookhub/api/user/register.php"),
            body: jsonEncode(<String, String>{
              'first_name': user.firstName,
              'middle_name': user.middleName,
              'last_name': user.lastName,
              'email': user.email,
              'password': user.password!,
            }));

    if (response.statusCode == 200) {
      print("Response: ${response.body}");
      if (jsonDecode(response.body) == "null") {
        return null;
      }
      return User.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  static Future<bool> borrowBook(
      int userId, Book book, int durationNo, String durationUnit) async {
    print("Hello");
    var response =
        await http.post(Uri.http(url, "/bookhub/api/request/add.php"),
            body: jsonEncode(<String, dynamic>{
              'user_id': userId,
              'book_id': book.id,
              'book_title': book.volumeInfo.title,
              'duration_no': durationNo,
              'duration_unit': durationUnit,
              'book_image': (book.volumeInfo.imageLinks?.isEmpty ?? true
                      ? ""
                      : book.volumeInfo.imageLinks!["smallThumbnail"])
                  .toString(),
            }));

    if (response.statusCode == 200) {
      if (jsonDecode(response.body) == "null") {
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  static Future<List<Book>> getBooks() async {
    var response = await http.get(Uri.http(url, "/bookhub/api/book/get.php"));

    if (response.statusCode == 200) {
      print("Response: ${response.body}");
      if (jsonDecode(response.body) == "null") {
        return [];
      }
      List<Book> books = [];
      for (var book in jsonDecode(response.body)) {
        books.add(Book.fromJson(book));
      }
      return books;
    } else {
      return [];
    }
  }

  static Future<List<Book>> getBookRequests(int userId) async {
    var response = await http.get(Uri.http(
        url,
        "/bookhub/api/request/get_request.php",
        {'user_id': userId.toString()}));
    print("${response.body}adsf");
    print(jsonDecode(response.body));
    List<Book> books = [];

    print(books);
    return books;
  }

  static Future<List<BorrowedBooks>> getBorrowedBooks(int userId) async {
    var response = await http.get(Uri.http(
        url,
        "/bookhub/api/books/borrowed_books.php",
        {'user_id': userId.toString()}));

    List<BorrowedBooks> books = [];
    print(response.body);
    for (var book in jsonDecode(response.body)) {
      books.add(BorrowedBooks.fromJson(book));
    }
    books.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    return books;
  }

  static Future<List<DBook.Book>> getFavorites(int userId) async {
    var response = await http.get(Uri.http(
        url,
        "/bookhub/api/favorites/get_favorites.php",
        {'user_id': userId.toString()}));
    List<DBook.Book> books = [];
    for (var book in jsonDecode(response.body)) {
      print(book);
      books.add(DBook.Book.fromJson(book));
    }
    return books;
  }

  static Future<List<BorrowedBooks>> getReturnedBooks(int userId) async {
    var response = await http.get(Uri.http(
        url,
        "/bookhub/api/books/returned_books.php",
        {'user_id': userId.toString()}));

    List<BorrowedBooks> books = [];
    print(response.body);
    for (var book in jsonDecode(response.body)) {
      books.add(BorrowedBooks.fromJson(book));
    }

    return books;
  }

  static Future<int> getDueCount(int userId) async {
    var response = await http.get(Uri.http(
        url,
        "/bookhub/api/books/get_due_count.php",
        {'user_id': userId.toString()}));

    if (response.statusCode == 200) {
      print("Response: ${response.body}");
      if (jsonDecode(response.body) == "null") {
        return 0;
      }
      return int.parse(jsonDecode(response.body)['due_count']);
    } else {
      return 0;
    }
  }

  static Future<bool> addFavorites(Book book, int userId) async {
    var response = await http.post(
        Uri.http(url, "/bookhub/api/favorites/add_favorites.php"),
        body: jsonEncode(<String, dynamic>{
          'user_id': userId,
          'book_id': book.id,
          'book_title': book.volumeInfo.title,
          'book_image': (book.volumeInfo.imageLinks?.isEmpty ?? true
                  ? ""
                  : book.volumeInfo.imageLinks!["smallThumbnail"])
              .toString(),
        }));
    print("Hello");
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> rateBook(String bookId, int rating, int userId) async {
    await http.post(Uri.http(url, "/bookhub/api/books/rate_book.php"),
        body: jsonEncode(<String, dynamic>{
          'book_id': bookId,
          'rating': rating,
          'user_id': userId
        }));
  }

  static Future<double> getRating(String bookId) async {
    var response = await http.get(Uri.http(
        url, "/bookhub/api/books/get_rating.php", {'book_id': bookId}));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) == "null") {
        return 0.0;
      }
      return double.parse(jsonDecode(response.body)['rating']);
    } else {
      return 0.0;
    }
  }
}
