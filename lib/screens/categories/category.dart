import 'package:flutter/material.dart';
import 'package:bookhub/screens/layout.dart';
import 'package:google_books_api/google_books_api.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String category = "";
  List<Book> books = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      category = ModalRoute.of(context)?.settings.arguments as String;
    });

    return LayoutPage(
        title: Text(category, style: const TextStyle(color: Colors.white)),
        child: FutureBuilder<List<Book>>(
            future: const GoogleBooksApi()
                .searchBooks(category, queryType: QueryType.subject),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      var isImagePresent =
                          snapshot.data![index].volumeInfo.imageLinks != null;
                      return Card(
                          margin: const EdgeInsets.all(1),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3)),
                          elevation: 2.0,
                          child: ListTile(
                              leading: isImagePresent
                                  ? Image.network(snapshot.data![index]
                                      .volumeInfo.imageLinks!["smallThumbnail"]
                                      .toString())
                                  : const Icon(Icons.book),
                              textColor:
                                  Theme.of(context).colorScheme.secondary,
                              title:
                                  Text(snapshot.data![index].volumeInfo.title),
                              subtitle: Text(snapshot
                                  .data![index].volumeInfo.authors
                                  .join(", ")),
                              onTap: () {
                                Navigator.pushNamed(context, "/book_details",
                                    arguments: snapshot.data![index]);
                              }));
                    });
              }
            }));
  }
}
