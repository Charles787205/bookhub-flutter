import 'package:bookhub/scripts/firebasehandler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    FirebaseHandler firebaseHandler = Provider.of<FirebaseHandler>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(firebaseHandler.gUser?.photoUrl ?? ""),
                ),
                Text(
                  "${firebaseHandler.user?.firstName} ${firebaseHandler.user?.lastName}" ??
                      "",
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  firebaseHandler.user?.email ?? "john@example.com",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Categories'),
            onTap: () {
              Navigator.pushNamed(context, "/categories");
            },
          ),
          ListTile(
            title: const Text('Borrowed Books'),
            onTap: () {
              Navigator.pushNamed(context, "/borrowed_books");
            },
          ),
          ListTile(
            title: const Text('Returned Books'),
            onTap: () {
              Navigator.pushNamed(context, "/returned_books");
            },
          ),
          ListTile(
            title: const Text('Favorites'),
            onTap: () {
              Navigator.pushNamed(context, "/favorites");
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              firebaseHandler.signOut();
              Navigator.pushNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
