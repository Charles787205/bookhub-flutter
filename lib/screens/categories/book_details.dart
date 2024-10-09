import 'package:bookhub/widgets/rate_dialog.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/scripts/firebasehandler.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:bookhub/widgets/borrow_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:bookhub/scripts/database.dart';

class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage({super.key});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var firebaseHandler = Provider.of<FirebaseHandler>(context);
    Book book = ModalRoute.of(context)?.settings.arguments as Book;
    var isBorrowed = firebaseHandler.isBorrowed(book.id);
    var isImagePresent = book.volumeInfo.imageLinks != null;

    var rating = firebaseHandler.getRating(book.id);
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            centerTitle: true,
            title: const Text(
              "Book Details",
              style: TextStyle(color: Colors.white),
            )),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  isImagePresent
                      ? Image.network(
                          book.volumeInfo.imageLinks!['thumbnail'].toString())
                      : const Icon(Icons.book_online),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    book.volumeInfo.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    book.volumeInfo.authors.join(", "),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "Description",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    book.volumeInfo.description.replaceAll("//n", "/n"),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  FutureBuilder(
                      future: rating,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            snapshot.data != null
                                ? snapshot.data.toString()
                                : "No rating",
                            style: const TextStyle(fontSize: 16),
                          );
                          /*
                          
                          return const CircularProgressIndicator();
                          */
                        } else {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Rating",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                snapshot.data != null
                                    ? snapshot.data.toString()
                                    : "No rating",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          );
                        }
                      }),
                  const SizedBox(
                    height: 60,
                  ),
                  FutureBuilder(
                      future: isBorrowed,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          if (snapshot.data == true) {
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  fixedSize: const Size(200, 30),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Return Book"),
                                          content: const Text(
                                              "Are you sure you want to return this book?"),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Cancel")),
                                            ElevatedButton(
                                                onPressed: () {
                                                  firebaseHandler
                                                      .returnBook(book.id);
                                                  Navigator.pop(context);
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              "Return Book"),
                                                          content: const Text(
                                                              "Book returned."),
                                                          actions: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "OK",
                                                                ))
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: const Text("Return"))
                                          ],
                                        );
                                      });
                                },
                                child: const Text(
                                  "Return Book",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ));
                          } else {
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  fixedSize: const Size(200, 30),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BorrowAlertDialog(book: book);
                                      });
                                },
                                child: const Text(
                                  "Borrow",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ));
                          }
                        }
                      })
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'favorite',
              child: const Icon(Icons.star),
              onPressed: () async {
                var isAdded = await firebaseHandler.addToFavorites(book.id);

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Favorites"),
                        content: Text(isAdded
                            ? "Book added to favorites."
                            : "Book removed from favorites."),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("OK"))
                        ],
                      );
                    });
              },
            ),
            const SizedBox(
              width: 10,
            ),
            FloatingActionButton(
                heroTag: 'rate',
                child: const Icon(Icons.star_half),
                onPressed: () async {
                  int? rating = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const RateDialog();
                      });

                  if (rating != null) {
                    firebaseHandler.addRating(rating, book.id);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Rating"),
                            content: const Text("Rating added."),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OK"))
                            ],
                          );
                        });
                  }
                })
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }
}
