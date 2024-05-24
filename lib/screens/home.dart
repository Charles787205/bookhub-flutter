import 'package:bookhub/components/auth_manager.dart';
import 'package:bookhub/screens/categories/book_details.dart';
import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:bookhub/widgets/dashboard_button.dart';
import 'package:bookhub/scripts/database.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isSearching = false;
  var searchText = "";
  Future<List<Book>> books = Future.value([]);
  var dueCount = 0;

  @override
  Widget build(BuildContext context) {
    if (searchText.isNotEmpty) {
      books = const GoogleBooksApi().searchBooks(searchText,
          queryType: QueryType.intitle,
          maxResults: 10,
          orderBy: OrderBy.relevance);
    }
    DatabaseConnector.getDueCount(context.read<AuthManager>().user!.id!)
        .then((value) {
      if (dueCount != value) {
        setState(() {
          dueCount = value;
        });
      }
    });

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: isSearching,
            leading: isSearching
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => setState(() {
                      isSearching = false;
                      FocusScope.of(context).unfocus();
                    }),
                  )
                : null,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            centerTitle: true,
            title: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(0),
                  //constraints: BoxConstraints(maxHeight: 40),
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search Book"),
              onTap: () {
                setState(() => isSearching = true);
              },
            )),
        body: !isSearching
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  crossAxisCount: 2,
                  children: <Widget>[
                    DashboardButton(
                      title: "Categories",
                      icon: Icons.category,
                      onPressed: () {
                        Navigator.pushNamed(context, "/categories");
                      },
                    ),
                    DashboardButton(
                      title: "Borrowed Books",
                      notificationCount: dueCount,
                      icon: Icons.access_alarm_outlined,
                      onPressed: () {
                        Navigator.pushNamed(context, "/borrowed_books");
                      },
                    ),
                    DashboardButton(
                      title: "Returned Books",
                      icon: Icons.account_circle_rounded,
                      onPressed: () {
                        Navigator.pushNamed(context, "/returned_books");
                      },
                    ),
                    DashboardButton(
                      title: "Favorites",
                      icon: Icons.account_circle_rounded,
                      onPressed: () {
                        Navigator.pushNamed(context, "/favorites");
                      },
                    ),
                    DashboardButton(
                      title: "Logout",
                      icon: Icons.accessibility_outlined,
                      onPressed: () {
                        context.read<AuthManager>().logout();
                        Navigator.pushNamed(context, "/login");
                      },
                    ),
                  ],
                ),
              )
            : FutureBuilder(
                future: books,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return snapshot.data != null
                        ? ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var isImagePresent =
                                  snapshot.data![index].volumeInfo.imageLinks !=
                                      null;
                              return Card(
                                  margin: const EdgeInsets.all(1),
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3)),
                                  elevation: 2.0,
                                  child: ListTile(
                                      leading: isImagePresent
                                          ? Image.network(snapshot
                                              .data![index]
                                              .volumeInfo
                                              .imageLinks!["smallThumbnail"]
                                              .toString())
                                          : const Icon(Icons.book),
                                      textColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      title: Text(snapshot
                                          .data![index].volumeInfo.title),
                                      subtitle: Text(snapshot
                                          .data![index].volumeInfo.authors
                                          .join(", ")),
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return BookDetailsPage(
                                              book: snapshot.data![index]);
                                        }));
                                      }));
                            })
                        : const Center(child: Text("No books found"));
                  }
                }));
  }
}
