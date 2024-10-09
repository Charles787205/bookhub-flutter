import 'package:bookhub/screens/categories/book_details.dart';
import 'package:bookhub/scripts/book_services.dart';
import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';

class BookCarousel extends StatefulWidget {
  final String category;
  const BookCarousel({super.key, required this.category});

  @override
  State<BookCarousel> createState() => _BookCarouselState();
}

class _BookCarouselState extends State<BookCarousel> {
  late Future<List<Book>> books;

  @override
  Widget build(BuildContext context) {
    books = const GoogleBooksApi()
        .searchBooks(widget.category, queryType: QueryType.subject);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 250),
      child: FutureBuilder(
          future: books,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : snapshot.hasError
                    ? Center(child: Text(snapshot.error.toString()))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: snapshot.data!.map((book) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, "/book_details",
                                    arguments: book);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      width: 150,
                                      child: book.volumeInfo.imageLinks != null
                                          ? Image.network(book.volumeInfo
                                              .imageLinks!["thumbnail"]
                                              .toString())
                                          : const SizedBox(
                                              child: Center(
                                                child: Text(
                                                    "No Image Available",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black12)),
                                              ),
                                            ),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        book.volumeInfo.title,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
          }),
    );
  }
}
