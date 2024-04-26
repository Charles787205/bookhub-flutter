import 'package:bookhub/components/auth_manager.dart';
import 'package:bookhub/objects/borrowed_books.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/screens/layout.dart';
import 'package:provider/provider.dart';
import 'package:bookhub/scripts/database.dart';

class BorrowedBooksPage extends StatefulWidget {
  const BorrowedBooksPage({super.key});

  @override
  State<BorrowedBooksPage> createState() => _BorrowedBooksPageState();
}

class _BorrowedBooksPageState extends State<BorrowedBooksPage> {
  @override
  Widget build(BuildContext context) {
    var userId = context.read<AuthManager>().user!.id!;
    Future<List<BorrowedBooks>> borrowedBooks =
        DatabaseConnector.getBorrowedBooks(userId);
    print(borrowedBooks);
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
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var dueDate = snapshot.data![index].dueDate;
                    var daysLeft = dueDate?.difference(DateTime.now()).inDays;

                    return Card(
                        margin: const EdgeInsets.all(1),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        elevation: 2.0,
                        child: ListTile(
                          leading: Image.network(
                              snapshot.data![index].book?.image ?? ""),
                          title: Text(snapshot.data![index].book?.title ?? ""),
                          subtitle: daysLeft! > 0
                              ? Text("Due in $daysLeft days")
                              : const Text(
                                  "Overdue",
                                  style: TextStyle(color: Colors.red),
                                ),
                        ));
                  });
            }
          }),
    );
  }
}
