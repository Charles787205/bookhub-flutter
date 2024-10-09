import 'package:bookhub/objects/returned_books.dart';
import 'package:bookhub/screens/returned_books/returned_books.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:bookhub/objects/borrowed_books.dart';
import "package:bookhub/objects/user.dart" as CustomObject;

class FirebaseHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  CustomObject.User? user;
  GoogleSignInAccount? gUser;

  Future<int> signIn() async {
    /**
     * returns 1 if user is already registered
     * returns 2 if user is not registered.
     * returns 0 if authentication failed.
     */
    try {
      _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      FirebaseAuth.instance.signInWithCredential(credential);

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('google_id', isEqualTo: googleUser?.id)
          .get();

      gUser = googleUser;
      if (snapshot.docs.isNotEmpty) {
        user = CustomObject.User(
          id: snapshot.docs[0].id,
          firstName: snapshot.docs[0].get('firstname'),
          lastName: snapshot.docs[0].get('lastname'),
          email: snapshot.docs[0].get('email'),
        );
        return 1; // user is found
      } else {
        return 2; // user is not found
      }
    } on AssertionError {
      return 2;
    } on StateError {
      return 2;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> registerUser(
      String firstName, String lastName, String year) async {
    try {
      final GoogleSignInAccount? googleUser = _googleSignIn.currentUser;

      var snapshot = await _firestore.collection('users').add({
        'firstname': firstName,
        'lastname': lastName,
        'google_id': googleUser?.id,
        'email': googleUser?.email,
        'year': year,
      });
      user = CustomObject.User(
          id: snapshot.id,
          firstName: firstName,
          lastName: lastName,
          email: googleUser!.email);
      gUser = googleUser;
      return true;
    } on Error {
      return false;
    }
  }

  Future<List<BorrowedBooks>> getBorrowedBooks() async {
    List<BorrowedBooks> books = [];

    var userId = user!.id;

    var bookList = await _firestore
        .collection('borrowed_books')
        .where('user_id', isEqualTo: userId)
        .get();

    for (var book in bookList.docs) {
      print(book.data()['borrowedAt']);
      var bookId = book.data()['book_id'];

      var borrowedBook = BorrowedBooks.fromJson(book.data());
      borrowedBook.book = await const GoogleBooksApi().getBookById(bookId);
      print(borrowedBook.book?.volumeInfo.imageLinks?['smallThumbnail']);
      books.add(borrowedBook);
      //i match ang data sa firebase ug sa borrowed books para mugana
    }

    return books;
  }

  Future<List<ReturnedBook>> getReturnedBooks() async {
    List<ReturnedBook> books = [];
    try {
      var bookList = await _firestore
          .collection('returned_books')
          .where('user_id', isEqualTo: user?.id)
          .get();

      for (var book in bookList.docs) {
        var bookId = book.get('book_id');
        var bookDetails = await const GoogleBooksApi().getBookById(bookId);
        var returnedBook = ReturnedBook.fromJson(book.data());
        returnedBook.book = bookDetails;
        books.add(returnedBook);
      }
      return books;
    } catch (e) {
      print(e);
      return books;
    }
  }

  Future<bool> borrowBook(
      Book book, int durationNo, String durationUnit) async {
    var dueDate = DateTime.now();
    switch (durationUnit) {
      case "DAY":
        dueDate = dueDate.add(Duration(days: durationNo));
        break;
      case "WEEK":
        dueDate = dueDate.add(Duration(days: durationNo * 7));
        break;
      case "MONTH":
        dueDate = dueDate.add(Duration(days: durationNo * 30));
        break;
    }

    try {
      print("the books is $book");
      await _firestore.collection("borrowed_books").add({
        'user_id': user!.id,
        'book_id': book.id,
        'book_title': book.volumeInfo.title,
        'borrowedAt': DateTime.now(),
        'due_date': dueDate,
        'image': book.volumeInfo.imageLinks!["smallThumbnail"].toString(),
        'title': book.volumeInfo.title,
        'returnedAt': null,
      }).then(
        (value) => true,
      );
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> isBorrowed(String bookId) async {
    var userId = user!.id;
    var borrowedBooks = await _firestore
        .collection('borrowed_books')
        .where('user_id', isEqualTo: userId)
        .where('book_id', isEqualTo: bookId)
        .where('returnedAt', isNull: true)
        .get();

    return borrowedBooks.docs.isNotEmpty;
  }

  Future<bool> returnBook(String bookId) async {
    var userId = user!.id;
    var borrowedBooks = await _firestore
        .collection('borrowed_books')
        .where('user_id', isEqualTo: userId)
        .where('book_id', isEqualTo: bookId)
        .where('returnedAt', isNull: true)
        .get();

    if (borrowedBooks.docs.isNotEmpty) {
      await _firestore
          .collection('borrowed_books')
          .doc(borrowedBooks.docs[0].id)
          .update({'returnedAt': DateTime.now()});

      await _firestore.collection('returned_books').add({
        'user_id': userId,
        'book_id': bookId,
        'returnedAt': DateTime.now(),
      });
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addToFavorites(String bookId) async {
    var userId = user!.id;
    var favorites = await _firestore
        .collection('favorites')
        .where('user_id', isEqualTo: userId)
        .where('book_id', isEqualTo: bookId)
        .get();

    if (favorites.docs.isEmpty) {
      await _firestore.collection('favorites').add({
        'user_id': userId,
        'book_id': bookId,
      });
      return true;
    } else {
      await removeFromFavorites(bookId);
      return false;
    }
  }

  Future<void> removeFromFavorites(String bookId) async {
    var userId = user!.id;
    var favorites = await _firestore
        .collection('favorites')
        .where('user_id', isEqualTo: userId)
        .where('book_id', isEqualTo: bookId)
        .get();

    if (favorites.docs.isNotEmpty) {
      await _firestore
          .collection('favorites')
          .doc(favorites.docs[0].id)
          .delete();
    }
  }

  Future<List<Book>> getFavorites() async {
    var userId = user!.id;
    var favorites = await _firestore
        .collection('favorites')
        .where('user_id', isEqualTo: userId)
        .get();

    List<Book> books = [];
    for (var favorite in favorites.docs) {
      var bookId = favorite.get('book_id');
      var book = await const GoogleBooksApi().getBookById(bookId);
      books.add(book);
    }

    return books;
  }

  Future<void> addRating(int rating, String bookId) async {
    var userId = user!.id;
    var ratings = await _firestore
        .collection('ratings')
        .where('user_id', isEqualTo: userId)
        .where('book_id', isEqualTo: bookId)
        .get();

    if (ratings.docs.isEmpty) {
      await _firestore.collection('ratings').add({
        'user_id': userId,
        'book_id': bookId,
        'rating': rating,
      });
    } else {
      await _firestore.collection('ratings').doc(ratings.docs[0].id).update({
        'rating': rating,
      });
    }
  }

  Future<double> getRating(String bookId) async {
    var ratings = await _firestore
        .collection('ratings')
        .where('book_id', isEqualTo: bookId)
        .get();

    if (ratings.docs.isEmpty) {
      return 0.0;
    }

    var totalRating = 0.0;
    for (var rating in ratings.docs) {
      totalRating += rating.get('rating');
    }

    return totalRating / double.parse(ratings.docs.length.toString());
  }
}
