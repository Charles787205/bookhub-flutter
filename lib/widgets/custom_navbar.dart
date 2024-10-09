import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    String? currentUrl = "";
    var activeIcon = 0;
    currentUrl = ModalRoute.of(context)?.settings.name;

    var links = [
      "/home",
      "/categories",
      "/borrowed_books",
      "/favorites",
      "/returned_books"
    ];

    if (currentUrl == "/category" || currentUrl == "/book_details") {
      currentUrl = "/categories";
    }

    return BottomNavigationBar(
        fixedColor: Colors.black87,
        unselectedItemColor: Colors.black38,
        selectedLabelStyle: const TextStyle(color: Colors.black87),
        unselectedLabelStyle: const TextStyle(color: Colors.black38),
        currentIndex: links.indexOf(currentUrl ?? '') == -1
            ? 0
            : links.indexOf(currentUrl ?? ''),
        onTap: (index) {
          Navigator.pushNamed(context, links[index]);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
              ),
              label: "Borrowed"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
              ),
              label: "Favorites"),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_available), label: "Returned")
        ]);
  }
}
