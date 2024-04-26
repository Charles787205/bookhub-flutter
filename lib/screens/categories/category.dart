import 'package:flutter/material.dart';
import 'package:bookhub/screens/layout.dart';
import "package:bookhub/scripts/book_services.dart";
import 'package:google_books_api/google_books_api.dart';
import 'package:bookhub/screens/categories/book_details.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Book> books = [];
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<List<Book>> fetchBooks() async {
    var booksQuery = await const GoogleBooksApi()
        .searchBooks(widget.category, queryType: QueryType.subject);
    setState(() {
      books = booksQuery;
    });
    return booksQuery;
  }

  @override
  Widget build(BuildContext context) {
    print(books.length);

    return LayoutPage(
        title:
            Text(widget.category, style: const TextStyle(color: Colors.white)),
        child: FutureBuilder<List<Book>>(
            future: BookServices.searchBooksByCategory(widget.category),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                print(books.length);
                return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      print(books[index].volumeInfo.imageLinks);
                      var isImagePresent =
                          books[index].volumeInfo.imageLinks != null;
                      return Card(
                          margin: const EdgeInsets.all(1),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          elevation: 2.0,
                          child: ListTile(
                              leading: isImagePresent
                                  ? Image.network(books[index]
                                      .volumeInfo
                                      .imageLinks!["smallThumbnail"]
                                      .toString())
                                  : const Icon(Icons.book),
                              textColor:
                                  Theme.of(context).colorScheme.secondary,
                              title: Text(books[index].volumeInfo.title),
                              subtitle: Text(
                                  books[index].volumeInfo.authors.join(", ")),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return BookDetailsPage(book: books[index]);
                                }));
                              }));
                    });
              }
            }));
  }
}
