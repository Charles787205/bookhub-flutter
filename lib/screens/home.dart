import 'package:bookhub/components/auth_manager.dart';
import 'package:bookhub/screens/categories/book_details.dart';
import 'package:bookhub/scripts/firebasehandler.dart';
import 'package:bookhub/widgets/book_carousel.dart';
import 'package:bookhub/widgets/custom_navbar.dart';
import 'package:bookhub/widgets/home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:bookhub/widgets/dashboard_button.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isSearching = false;
  var searchText = "";
  Future<List<Book>> books = Future.value([]);
  var dueCount = 0;

  Future<List<Book>> getBooks() async {
    var booksQuery = await const GoogleBooksApi()
        .searchBooks("Harry Potter", queryType: QueryType.intitle);
    return booksQuery;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseHandler firebaseHandler = Provider.of<FirebaseHandler>(context);
    if (searchText.isNotEmpty) {
      books = const GoogleBooksApi().searchBooks(searchText,
          queryType: QueryType.intitle,
          maxResults: 10,
          orderBy: OrderBy.relevance);
    }
    books.then((value) {
      print(value);
    }, onError: (error) {
      print("HTe problem $error");
    });

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: _isSearching,
          leading: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() {
                    _isSearching = false;
                    FocusScope.of(context).unfocus();
                  }),
                )
              : Builder(
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                      child: RawMaterialButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              firebaseHandler.gUser!.photoUrl ?? ""),
                        ),
                      ),
                    );
                  },
                ),
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
              setState(() => _isSearching = true);
            },
          )),
      drawer: HomeDrawer(),
      bottomNavigationBar: const CustomNavbar(),
      body: !_isSearching
          ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Horror",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      BookCarousel(category: "horror"),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Thriller",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      BookCarousel(category: "thriller"),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Romance",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      BookCarousel(category: "romance"),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Fantasy",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      BookCarousel(category: "fantasy"),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Action",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      BookCarousel(category: "action"),
                    ],
                  )))
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
                                    textColor:
                                        Theme.of(context).colorScheme.secondary,
                                    title: Text(
                                        snapshot.data![index].volumeInfo.title),
                                    subtitle: Text(snapshot
                                        .data![index].volumeInfo.authors
                                        .join(", ")),
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/book_details",
                                          arguments: snapshot.data![index]);
                                    }));
                          })
                      : const Center(child: Text("No books found"));
                }
              }),
    );
  }
}
