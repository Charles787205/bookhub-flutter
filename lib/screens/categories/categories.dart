import 'package:flutter/material.dart';
import "package:bookhub/screens/layout.dart";
import "package:bookhub/objects/categories.dart";
import 'package:bookhub/screens/categories/category.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutPage(
        title: const Text(
          "Categories",
          style: TextStyle(color: Colors.white),
        ),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: Categories.values.length,
                itemBuilder: (context, index) {
                  return Card.filled(
                      margin: const EdgeInsets.all(1),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                      elevation: 2.0,
                      child: ListTile(
                          textColor: Theme.of(context).colorScheme.secondary,
                          title: Text(Categories.values[index]
                              .toString()
                              .split(".")[1]
                              .replaceAll("_", " ")),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CategoryPage(
                                  category: Categories.values[index]
                                      .toString()
                                      .split(".")[1]);
                            }));
                          }));
                })));
  }
}
