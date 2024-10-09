import 'package:bookhub/objects/borrowed_books.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/screens/layout.dart';
import 'package:provider/provider.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:bookhub/scripts/firebasehandler.dart';

class BorrowedBooksPage extends StatefulWidget {
  const BorrowedBooksPage({super.key});

  @override
  State<BorrowedBooksPage> createState() => _BorrowedBooksPageState();
}

class _BorrowedBooksPageState extends State<BorrowedBooksPage> {
  @override
  Widget build(BuildContext context) {
    FirebaseHandler firebaseHandler = Provider.of<FirebaseHandler>(context);

    Future<List<BorrowedBooks>> borrowedBooks =
        firebaseHandler.getBorrowedBooks();

    print(borrowedBooks);
    void onCardClick(String bookId) async {
      Book book = await const GoogleBooksApi().getBookById(bookId);
      if (context.mounted) {
        Navigator.pushNamed(context, "/book_details", arguments: book);
      }
    }

    return LayoutPage(
      title: const Text(
        "Borrowed Books",
        style: TextStyle(color: Colors.white),
      ),
      child: FutureBuilder<List<BorrowedBooks>>(
          future: borrowedBooks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.toString()));
            } else {
              print(" the data is this ${snapshot.data}");
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var dueDate = snapshot.data![index].dueDate;
                    var daysLeft = dueDate?.difference(DateTime.now()).inDays;
                    print("the due date is $dueDate");
                    return Card(
                        margin: const EdgeInsets.all(1),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        elevation: 2.0,
                        child: ListTile(
                          leading: Image.network(snapshot.data![index].book
                                  ?.volumeInfo.imageLinks?['smallThumbnail']
                                  .toString() ??
                              ""),
                          title: Text(
                              snapshot.data![index].book?.volumeInfo.title ??
                                  ""),
                          subtitle: daysLeft! > 0
                              ? Text("Due in $daysLeft days")
                              : const Text(
                                  "Overdue",
                                  style: TextStyle(color: Colors.red),
                                ),
                          onTap: () => onCardClick(snapshot.data![index].id!),
                        ));
                  });
            }
          }),
    );
  }
}
