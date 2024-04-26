import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/screens/login.dart';
import 'package:bookhub/screens/register.dart';
import 'package:bookhub/components/auth_manager.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:bookhub/screens/home.dart';
import 'package:bookhub/screens/categories/categories.dart';
import 'package:bookhub/screens/categories/category.dart';
import 'package:bookhub/screens/borrowed_books/borrowed_books.dart';
import 'package:bookhub/screens/returned_books/returned_books.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthManager(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 241, 213, 152)),
        primaryColor: Color.fromARGB(255, 247, 188, 111),
        useMaterial3: true,
      ),
      home: Consumer<AuthManager>(builder: (context, authManager, _) {
        if (authManager.user == null) {
          return const LoginPage();
        }
        return const HomePage();
      }),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/categories': (context) => const CategoriesPage(),
        '/borrowed_books': (context) => const BorrowedBooksPage(),
        '/returned_books': (context) => const ReturnedBooksPage()
      },
    );
  }
}
