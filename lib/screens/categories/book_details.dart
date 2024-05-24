import 'package:bookhub/widgets/rate_dialog.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/components/auth_manager.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:bookhub/widgets/borrow_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:bookhub/scripts/database.dart';

class BookDetailsPage extends StatefulWidget {
  final Book book;
  const BookDetailsPage({super.key, required this.book});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var isImagePresent = widget.book.volumeInfo.imageLinks != null;
    var book = widget.book;
    var userId = context.read<AuthManager>().user!.id!;
    var rating = DatabaseConnector.getRating(book.id);
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
                      ? Image.network(widget
                          .book.volumeInfo.imageLinks!['thumbnail']
                          .toString())
                      : const Icon(Icons.book_online),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.book.volumeInfo.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.book.volumeInfo.authors.join(", "),
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
                    widget.book.volumeInfo.description.replaceAll("//n", "/n"),
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
                          return const CircularProgressIndicator();
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
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
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
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      )),
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
              onPressed: () {
                DatabaseConnector.addFavorites(book, userId);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Favorites"),
                        content: const Text("Book added to favorites."),
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
                        return RateDialog();
                      });
                  if (rating != null) {
                    DatabaseConnector.rateBook(book.id, userId, rating);
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
