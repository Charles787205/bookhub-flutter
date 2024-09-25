import 'package:flutter/material.dart';

import 'package:bookhub/scripts/firebasehandler.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseHandler = Provider.of<FirebaseHandler>(context);
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            var userType = await firebaseHandler.signIn();

            if (userType == 1) {
              //user is already registered
              if (context.mounted) {
                Navigator.of(context).pushNamed("/home");
              }
            }
            if (userType == 2) {
              if (context.mounted) {
                Navigator.of(context).pushNamed("/register");
              }
            }
            print(userType);
            if (userType == 0) {
              if (context.mounted) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                          actions: [], title: const Text("Error on loggin in"));
                    });
              }
            }
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
