import 'package:bookhub/firebase_options.dart';
import 'package:bookhub/scripts/firebasehandler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/screens/login.dart';
import 'package:bookhub/screens/register.dart';

import 'package:provider/provider.dart';
import 'package:bookhub/screens/home.dart';
import 'package:bookhub/screens/categories/categories.dart';

import 'package:bookhub/screens/borrowed_books/borrowed_books.dart';
import 'package:bookhub/screens/returned_books/returned_books.dart';
import 'package:bookhub/screens/favorites/favorites.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseHandler firebaseHandler = FirebaseHandler();
  runApp(MultiProvider(
    providers: [Provider<FirebaseHandler>(create: (_) => firebaseHandler)],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseHandler firebaseHandler = Provider.of<FirebaseHandler>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 241, 213, 152)),
        primaryColor: const Color.fromARGB(255, 247, 188, 111),
        useMaterial3: true,
      ),
      home: firebaseHandler.user != null ? HomePage() : LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/categories': (context) => const CategoriesPage(),
        '/borrowed_books': (context) => const BorrowedBooksPage(),
        '/returned_books': (context) => const ReturnedBooksPage(),
        '/favorites': (context) => const Favorites(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
