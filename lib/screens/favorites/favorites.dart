import 'package:bookhub/components/auth_manager.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:bookhub/screens/categories/book_details.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/screens/layout.dart';
import 'package:bookhub/widgets/rate_dialog.dart';
import 'package:provider/provider.dart';
import 'package:bookhub/scripts/database.dart';
import 'package:bookhub/objects/db_book.dart' as dbBook;

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    var userId = context.read<AuthManager>().user!.id!;
    Future<List<dbBook.Book>> books = DatabaseConnector.getFavorites(userId);

    void onCardClick(String bookId) async {
      Book book = await const GoogleBooksApi().getBookById(bookId);
      if (context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookDetailsPage(book: book)));
      }
    }

    return LayoutPage(
      title: const Text(
        "Favorites",
        style: TextStyle(color: Colors.white),
      ),
      child: FutureBuilder<List<dbBook.Book>>(
          future: books,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                        margin: const EdgeInsets.all(1),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        elevation: 2.0,
                        child: ListTile(
                          leading:
                              Image.network(snapshot.data![index].image ?? ""),
                          title: Text(snapshot.data![index].title ?? ""),
                          onTap: () => {onCardClick(snapshot.data![index].id)},
                        ));
                  });
            }
          }),
    );
    ;
  }
}
