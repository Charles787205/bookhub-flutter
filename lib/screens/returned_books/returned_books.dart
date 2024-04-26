import 'package:bookhub/components/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/screens/layout.dart';
import 'package:bookhub/scripts/database.dart';
import 'package:provider/provider.dart';

class ReturnedBooksPage extends StatefulWidget {
  const ReturnedBooksPage({super.key});

  @override
  State<ReturnedBooksPage> createState() => _ReturnedBooksPageState();
}

class _ReturnedBooksPageState extends State<ReturnedBooksPage> {
  @override
  Widget build(BuildContext context) {
    var userId = context.read<AuthManager>().user!.id!;
    var returnedBooks = DatabaseConnector.getReturnedBooks(userId);
    return LayoutPage(
        title:
            const Text("Returned Books", style: TextStyle(color: Colors.white)),
        child: FutureBuilder(
            future: returnedBooks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                print(snapshot);
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var returnedAt = snapshot.data![index].returnedAt;
                        var daysReturned =
                            DateTime.now().difference(returnedAt!).inDays;

                        return Card(
                            margin: const EdgeInsets.all(1),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            elevation: 2.0,
                            child: ListTile(
                              leading: Image.network(
                                  snapshot.data![index].book?.image ?? ""),
                              title:
                                  Text(snapshot.data![index].book?.title ?? ""),
                              subtitle: Text(
                                daysReturned > 1
                                    ? "$daysReturned days ago"
                                    : daysReturned != 0
                                        ? "$daysReturned day ago"
                                        : "Today",
                              ),
                            ));
                      });
                } else {
                  return const Center(
                    child: Text("No returned books"),
                  );
                }
              }
            }));
  }
}
